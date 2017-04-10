# Happenings Server

## Heroku Versions

### Staging

ruby 2.4.1
rails 5.0.2
postgres 9.6.2
elasticsearch 5.1.2

### Production

ruby 2.4.1
rails 5.0.2
postgres 9.6.2
elasticsearch 5.1.2

## Installation

`rails new happenings-server --database=postgresql --skip-spring --skip-turbolinks --skip-test --skip-action-cable`

## Heroku Setup

* Deploys from Github master branch
* Utilizes Heroku CI (beta)
* `git remote add staging https://git.heroku.com/happenings-server-staging.git`
* `git remote add production https://git.heroku.com/happenings-server-production.git`
