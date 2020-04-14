alias be="bundle exec"
alias ber="bundle exec rails"
alias bek="bundle exec rake"
alias gs="git status"

# Usage : use the function, followed by the name of the component
#
# create_demo_page calendar
#
create_demo_page() {
  awk '/Rails.application.routes.draw do/ { print; print "  get \x27'''/$1'''\x27, to: \x27'''$1#index'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
  echo -e "added \e[32m'get /$1'\e[0m route under \e[32mconfig/routes.rb\e[0m"

  printf "console.log('$1 loaded')\n" > app/javascript/packs/$1.js
  echo -e "added a very simple \e[32mapp/javascript/packs/$1.js\e[0m"
  
  printf "class ${1^}Controller < ApplicationController\nend" > app/controllers/$1_controller.rb
  echo -e "added an empty \e[32mapp/controllers/$1_controller.rb\e[0m"
  
  mkdir "app/views/$1"
  printf "<%%= javascript_pack_tag '$1' %%>\n<h1 class='c-$1'>${1^}</h1>\n" > app/views/$1/index.html.erb
  echo -e "added simple view under \e[32mapp/views/$1/index.html.erb\e[0m"

  truncate -s 0 "app/assets/stylesheets/application.css"
  printf "/* = require_self */\n/* = require main */" > app/assets/stylesheets/application.css
  touch app/assets/stylesheets/main.scss
  printf "@import \"components/$1.scss\";\n" >> app/assets/stylesheets/main.scss
  mkdir -p app/assets/stylesheets/components
  printf ".c-$1 {\n  color: green;\n}\n" > app/assets/stylesheets/components/$1.scss
  echo -e "added css component under \e[32mapp/assets/stylesheets/components/$1.scss\e[0m"
}

# Usage : use the function, followed by the Rails version number. Example :
#
# create_new_rails_app 6.0.2.2
#
create_new_rails_app() {

  # It will install in the "bundle" path the rails with supplied version
  gem install rails -v "$1"

  # Skip bundle,  since "rails new" will rely on internal ruby bundler
  # instead of the one defined in our Dockerfile, creating bugs and inconsistencies.
  #
  # Use postgresql so that we rely on only one kind of database on all environments.
  #
  # Skip webpack-install since it relies on wrong bundler
  rails new . --skip --skip-bundle --skip-webpack-install --skip-sprockets --database=postgresql 

  # bundle everything with the correct bundler (defined in Docker)
  bundle install
  # webpacker:install is now possible
  bundle exec rails webpacker:install

  # HACK : replace check_yarn_integrity true to false to avoid weird yarn behaviour
  # Simply adds "check_yarn_integrity: false" to the config/webpacker.yml
  sed -i.bak 's/check_yarn_integrity: true/check_yarn_integrity: false/g' config/webpacker.yml
  # WEBPACKER : : map host to the one provided by the docker service
  sed -i.bak 's/host: localhost/host: webpacker/g' config/webpacker.yml

  # DOCKER : map database host to the one provided by the docker service
  # Simply adds "host: postgres" to the config/database.yml
  awk '/pool:/ { print; print "  host: postgres"; next }1' config/database.yml > config/tmp && mv config/tmp config/database.yml

}
