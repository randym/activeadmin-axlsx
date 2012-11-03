require 'rails'
require 'activeadmin'

ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{Rails::VERSION::STRING}", __FILE__)

unless File.exists?(ENV['RAILS_ROOT'])
  puts "Please run bundle exec rake setup before running the specs."
  exit
end

def load_defaults!
  ActiveAdmin.unload!
  ActiveAdmin.load!
  ActiveAdmin.register(Category)
  ActiveAdmin.register(User)
  ActiveAdmin.register(Post){ belongs_to :user, :optional => true }
end

ENV['RAILS_ENV'] = 'test'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]
require ENV['RAILS_ROOT'] + '/config/environment'
require 'activeadmin-axlsx'
