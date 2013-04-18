require 'simplecov'
SimpleCov.start do
  add_filter "/rails/"
end

# prepare ENV for rails
require 'rails'
ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{Rails::VERSION::STRING}", __FILE__)

# ensure testing application is in place
unless File.exists?(ENV['RAILS_ROOT'])
  puts "Please run bundle exec rake setup before running the specs."
  exit
end

# load up activeadmin and activeadmin-axlsx
require 'activeadmin-axlsx'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]
# start up rails
require ENV['RAILS_ROOT'] + '/config/environment'

# and finally,here's rspec
require 'rspec/rails'
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false
