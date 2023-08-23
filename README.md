# rinha-backend-ruby

```
     _      _           _             _               _            _         
 _ _(_)_ _ | |_  __ _  | |__  __ _ __| |_____ _ _  __| |  _ _ _  _| |__ _  _ 
| '_| | ' \| ' \/ _` | | '_ \/ _` / _| / / -_) ' \/ _` | | '_| || | '_ \ || |
|_| |_|_||_|_||_\__,_| |_.__/\__,_\__|_\_\___|_||_\__,_| |_|  \_,_|_.__/\_, |
                                                                        |__/ 
```

Yet another Ruby version for [rinha do backend](https://github.com/zanfranceschi/rinha-de-backend-2023-q3)

## Requirements

* [Docker](https://docs.docker.com/get-docker/)
* [curl](https://curl.se/download.html)
* [Gatling](https://gatling.io/open-source/), a performance testing tool
* Make (optional)

## Stack

* Ruby 3.2 [+YJIT](https://shopify.engineering/ruby-yjit-is-production-ready)
* PostgreSQL
* NGINX

## Usage

```bash
$ make help

Usage: make <target>
  help                       Prints available commands
  start.dev                  Start the rinha in Dev
  start.prod                 Start the rinha in Prod
  docker.stats               Show docker stats
  health.check               Check the stack is healthy
  stress.it                  Run stress tests
  docker.build               Build the docker image
  docker.push                Push the docker image
```

## Starting the app

Start the stack (1 NGINX + 2 Ruby apps + 1 PostgreSQL) using the [public image](https://hub.docker.com/r/leandronsp/rinha-backend-ruby) `leandronsp/rinha-backend-ruby`:

```bash
$ docker compose -f docker-compose-prod.yml up -d nginx

# Or using make
$ make start.prod
```

Or, in case you want to run using local build and volumes:

```bash
$ docker compose up -d nginx

# Or using make
$ make start.dev
```

## Unleash the madness

Make sure you copy all the resource/simulation files and Gatling script to the project and:

```bash
$ make stress.it 
$ open stress-test/user-files/results/**/index.html
```

----

[ASCII art generator](http://www.network-science.de/ascii/)
