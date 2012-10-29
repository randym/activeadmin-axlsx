#!/usr/bin/env rake
require "activeadmin"
require "rspec/core/rake_task"

desc "Creates a test rails app for the specs to run against"
task :setup do
 ACTIVE_ADMIN_PATH = "#{ENV['GEM_HOME']}/gems/activeadmin-#{ActiveAdmin::VERSION}"
  require 'rails/version'
  system "bundle exec rails new #{ACTIVE_ADMIN_PATH}/spec/rails/rails-#{Rails::VERSION::STRING} -m #{ACTIVE_ADMIN_PATH}/spec/support/rails_template.rb"
end

RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec
