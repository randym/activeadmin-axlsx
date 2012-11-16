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
  @xlsx_config = ActiveAdmin.register Category do
    xlsx :i18n_scope => [:fishery], :header_style => { :sz => 14 } do
      column(:block) { |resource_item| "blocked content" }
      ignore_columns :id
      after_filter do |worksheet|
        worksheet.add_row ['look mom, no hands!']
      end
    end
  end
  ActiveAdmin.register(User)
  ActiveAdmin.register(Post){ belongs_to :user, :optional => true }
end

ENV['RAILS_ENV'] = 'test'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]
require ENV['RAILS_ROOT'] + '/config/environment'
require 'activeadmin-axlsx'
