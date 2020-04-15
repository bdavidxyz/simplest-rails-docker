# Simplest Rails 6 + Docker fails

This repository is intended to be the simplest possible Rails 6 + Docker demo.

It tries to build and run a simple "hello" page locally.

Rails, Database and webpacker are the 3 mandatory services to get things works.

## Steps to reproduce

### 0. Prerequisites

```
$> docker -v
Docker version 17.12.0-ce

$> docker-compose -v
docker-compose version 1.18.0
```

Any upper version should work.


### 1. Build images
Run :
```
docker-compose build
```

### 2. Build project

Run :
```
docker-compose run --no-deps web rails new . --skip --database=postgresql
```

This will run the `rails new` command on our `web` service defined in docker-compose.yml.

Flag explanations:
* **--no-deps** - Tells `docker-compose run` not to start any of the services in `depends_on`.
* **--skip** - Tells rails NOT to overwrite existing files, such as README or .gitignore
* **--database=postgresql** - Tells Rails to default our db config to use postgres.

### 3. Adapt database.yml and webpacker.yml to Docker configuration

Open and change config/database.yml
```
default: &default
  host: db # <---- add this property
  username: postgres # <---- add this property
  password: # <---- add this empty property
```

Open and change config/webpacker.yml
```
development:
 (...)
  dev_server:
    https: false
    host: webpack # <---- changed here, value was localhost
    port: 3035
    public: webpack:3035 # <---- changed here, value was localhost:3035
```

### 4. Create hello world page

Run :
```
docker-compose run --rm --no-deps web rails generate controller hello say_hello
```

Flag explanations:
* **--no-deps** - Tells `docker-compose run` not to start any of the services in `depends_on`.
* **--rm** - Removes container after run

### 5. Start services

```
docker-compose up
```

### 6. Visit "hello world" page

go to http://localhost:3000/hello/say_hello


## Restart from scratch

reset docker
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q) -f
docker volume prune
```

reset files
```
rm -rf -v !("Dockerfile"|".dockerenv"|".gitignore"|"README_first.md"|"docker-compose.yml") && rm .browserslistrc && rm .ruby-version
```

