source "https://rubygems.org"

ruby "2.4.1"
gem "rails", "~> 5.0.2"

# global
# gem install bundler
# gem install foreman

gem "active_model_serializers", "0.10.5"
gem "activeadmin", "1.0.0.pre5"
gem "devise", "4.2.1"
gem "faker", "1.7.3"
gem "figaro", "1.1.1"
gem "hirefire-resource", "0.4.0"
gem "inherited_resources", "1.7.1"
gem "kaminari", "1.0.1"
gem "money-rails", "1.8.0"
gem "pg", "0.20.0"
gem "postmark-rails", "0.15.0"
gem "puma", "3.8.2"
gem "pundit", "1.1.0"
gem "sass-rails", "5.0.6"
gem "searchkick", "2.2.0"
gem "settingslogic", "2.0.9"
gem "sidekiq", "4.2.10"
gem "sidekiq-failures", "0.4.5"
gem "snitcher", "0.4.0"
gem "state_machines", "0.4.0"
gem "state_machines-activerecord", "0.4.0"
gem "uglifier", "3.2.0"

# JavaScript
gem "jquery-rails"

group :production do
  gem "rollbar", "2.14.1"
  gem "scout_apm", "2.1.23"
end

group :development, :test do
  gem "brakeman", "3.6.1", require: false
  gem "bundler-audit", "0.5.0", require: false
  gem "byebug", "9.0.6"
  gem "factory_girl_rails", "4.8.0"
  gem "hakiri", "0.7.2", require: false
  gem "pry-byebug", "3.4.2"
  gem "pry-rails", "0.3.6"
  gem "pry-remote", "0.1.8"
  gem "rails_db", "1.5.0"
  gem "rubocop", "0.48.1"
  gem "state_machines_rspec", "0.3.2"
end

group :development do
  gem "letter_opener_web", "1.3.1"
  gem "listen", "3.1.5"
  gem "web-console", "3.5.0"
  gem "yard", "0.9.8"
end

group :test do
  gem "capybara", "2.13.0"
  gem "database_cleaner", "1.5.3"
  gem "pry-doc", "0.10.0"
  gem "pundit-matchers", "1.2.3"
  gem "rspec-instafail", "1.0.0", require: false
  gem "rspec-json_expectations", "2.1.0"
  gem "rspec-rails", "3.5.2"
  gem "rspec-retry", "0.5.3"
  gem "rspec-sidekiq", "3.0.1"
  gem "rspec_junit_formatter", "0.2.3"
  gem "rubocop-rspec", "1.15.0"
  gem "selenium-webdriver", "3.3.0"
  gem "shoulda-matchers", "3.1.1"
  gem "timecop", "0.8.1"
end
