# Simplest Rails 6 + Docker fails

This repository is intended to be the simplest possible Rails 6 + Docker demo.

It tries to build and run a simple "hello" page locally.

Rails, Database and webpacker are the 3 mandatory services to get things works.

## Steps to reproduce

### 1. Build images

### 2. Build project

Run :
```
docker-compose run --no-deps web rails new . --force --database=postgresql
```

This will run the `rails new` command on our `web` service defined in docker-compose.yml.

Flag explanations:
* **--no-deps** - Tells `docker-compose run` not to start any of the services in `depends_on`.
* **--force** - Tells rails to overwrite existing files, such as Gemfile.
* **--database=postgresql** - Tells Rails to default our db config to use postgres.


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
rm -rf -v !(".dockerenv"|".gitignore"|"README_first.md"|"docker-compose.yml") && rm .browserslistrc && rm .ruby-version
```

