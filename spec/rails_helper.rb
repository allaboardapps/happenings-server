ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "capybara/rspec"
require "rake"
require "spec_helper"
require "rspec/rails"
require "sidekiq/testing"
require "money-rails/test_helpers"

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :selenium_with_long_timeout do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 90
  Capybara::Selenium::Driver.new(app, browser: :chrome, http_client: client)
end

Capybara.javascript_driver = :selenium_with_long_timeout

Capybara.raise_server_errors = true

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.include ActiveJob::TestHelper
  config.include StateMachinesRspec::Matchers, type: :model

  config.filter_rails_from_backtrace!
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
  config.default_retry_count = 2
  config.exceptions_to_retry = [Net::ReadTimeout] # Retry when Selenium raises Net::ReadTimeout

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    ActionMailer::Base.deliveries.clear
  end

  config.before(:all, elasticsearch: true) do
    Item.searchkick_index.delete if Item.searchkick_index.exists?
  end

  config.before(:each, elasticsearch: true) do
    Item.reindex
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    Warden.test_reset!
    clear_enqueued_jobs
    clear_performed_jobs
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec::Sidekiq.configure do |config|
  config.clear_all_enqueued_jobs = true
  config.enable_terminal_colours = true
  config.warn_when_jobs_not_processed_by_sidekiq = false
end
