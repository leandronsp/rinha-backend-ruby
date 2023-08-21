# rinha-backend-ruby

```
     _      _           _             _               _            _         
 _ _(_)_ _ | |_  __ _  | |__  __ _ __| |_____ _ _  __| |  _ _ _  _| |__ _  _ 
| '_| | ' \| ' \/ _` | | '_ \/ _` / _| / / -_) ' \/ _` | | '_| || | '_ \ || |
|_| |_|_||_|_||_\__,_| |_.__/\__,_\__|_\_\___|_||_\__,_| |_|  \_,_|_.__/\_, |
                                                                        |__/ 
```

Yet another Ruby version for [rinha do backend](https://github.com/zanfranceschi/rinha-de-backend-2023-q3)

![gatling report](https://github.com/leandronsp/rinha-backend-ruby/blob/main/screenshots/gatling.png?raw=true)

## Requirements

* [Docker](https://docs.docker.com/get-docker/)
* [curl](https://curl.se/download.html)
* [Gatling](https://gatling.io/open-source/), a performance testing tool

## Stack

* Ruby 3.2 [+YJIT](https://shopify.engineering/ruby-yjit-is-production-ready)
* PostgreSQL
* NGINX

Highlights:

1. Two Ruby apps behind NGINX
2. Each app running Puma, a multi-threaded HTTP server
3. Puma using a pool up to 5 threads
4. [Chespirito](https://github.com/leandronsp/chespirito), a tiny Rack-based web framework
5. A database pool of 5 connections for each Puma app
6. Search based on pg_trgm and GIN index

## Usage

```bash
$ make help

Usage: make <target>
  help                       Prints available commands
  start                      Start the rinha
  docker.stats               Show docker stats
  health.check               Check the stack is healthy
  stress.it                  Run stress tests
  docker.build               Build the docker image
  docker.push                Push the docker image
```

## Stress it!

```bash
$ make start                 # Start the stack (1 NGINX + 2 Ruby apps + 1 PostgreSQL)
$ make stress.it             # Unleash the madness

$ open stress-test/user-files/results/**/index.html
```
----

[ASCII art generator](http://www.network-science.de/ascii/)
