# Happenings Server

## Annotations in the codebase

* Ref: http://guides.rubyonrails.org/command_line.html#notes
* View annotations in the command line with `rails notes`
* Notes in `rb` files need to be written as `# TODO: This is a task`
* Notes in `js` files need to be written as `// TODO This is a task %>`
* Notes in `scss, css` files need to be written as `// TODO This is a task`
* Notes in `erb` files need to be written as `<% TODO This is a task %>`
* You must have `SOURCE_ANNOTATION_DIRECTORIES: "spec"` specified in your environment variables for spec file annotations to be captured.

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

## Security Checks

* run `bundle outdated` > update gems with `bundle update` > run tests
* run `bundle-audit update`
* run `bundle-audit`
* run `brakeman`
* run `hakiri system:steps`
* run `hakiri manifest:generate` > `hakiri system:scan`
* run `hakiri gemfile:scan`

## Security References

* [How Do Ruby/Rails Developers Keep Updated on Security Alerts?](http://gavinmiller.io/2015/staying-up-to-date-with-security-alerts/)
* [Ruby Security Mailing List](https://groups.google.com/forum/#!forum/ruby-security-ann)
* [Rails Security Mailing List](https://groups.google.com/forum/?fromgroups#!forum/rubyonrails-security)
* [CVE Details](https://www.cvedetails.com/)
* [Hakiri service (fee-based)](https://hakiri.io/)
* [AppCanary service (fee-based)](https://appcanary.com/)

### Setup Heroku

First, you'll need to ask to be added as a collaborator to the Heroku projects for access.

Second, you'll need to connect your local git repo to the heroku repos:
* connect to staging: `git remote add staging https://git.heroku.com/happenings-server-staging.git`
* connect to production: `git remote add production https://git.heroku.com/happenings-server-production.git`
* review your remotes: `git remote -v`

You should see something like this:
```
origin  https://github.com/allaboardapps/happenings-server-server.git (fetch)
origin  https://github.com/allaboardapps/happenings-server-server.git (push)
production  https://git.heroku.com/happenings-server-production.git (fetch)
production  https://git.heroku.com/happenings-server-production.git (push)
staging https://git.heroku.com/happenings-server-staging.git (fetch)
staging https://git.heroku.com/happenings-server-staging.git (push)
```

### Setup RVM

* Ref: https://gist.github.com/wrburgess/a6fc079cee6f14fc601b1
* Install with curl: `\curl -sSL https://get.rvm.io | bash -s stable`
* Source RVM: `source /Users/[user]/.rvm/scripts/rvm`
* As a routine process, you may want to update with: `rvm get stable`

### Setup Ruby

* Ref: https://gist.github.com/wrburgess/a6fc079cee6f14fc601b
* Update ruby: `rvm get stable --ruby`
* Confirm ruby version changed: `ruby -v`
* Create `.ruby-version` file in root dir with ruby version number, ex: `2.4.1`

### Setup Rails

* Note: This app utilizes `uuid` data types for all model/table ids.
* Ref: (Rails 5 UUIDs) https://gist.github.com/wrburgess/c1678788181d5f5577c6e84ac5a3efab

### Setup Environment Variables

* Ref: https://github.com/laserlemon/figaro
* Note: We use the figaro gem to store and access env variables out of the reach of source control
* Note: You will need to retrieve the valid variables from a team member and place the contents in the `/config/application.yml` file.
