require 'rails'
require 'activeadmin'

DEFAULT_RAILS_VERSION = Rails::VERSION::STRING
ACTIVE_ADMIN_PATH = "#{ENV['GEM_HOME']}/gems/activeadmin-#{ActiveAdmin::VERSION}"
ENV['RAILS_ROOT'] = "#{ACTIVE_ADMIN_PATH}/spec/rails/rails-#{DEFAULT_RAILS_VERSION}"
# Create the test app if it doesn't exists
unless File.exists?(ENV['RAILS_ROOT'])
  puts "Please run bundle exec rake setup before running the specs."
  exit
end
require "#{ACTIVE_ADMIN_PATH}/spec/spec_helper"
require 'activeadmin-axlsx'

