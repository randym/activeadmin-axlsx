source 'https://rubygems.org'
gem 'axlsx'
gem 'activeadmin', github: 'gregbell/active_admin'
gemspec

group :development, :test do
  gem 'sqlite3'
  gem 'haml', :require => false
  gem 'yard'
  gem 'rdiscount' # For yard
  gem "sprockets"
  gem 'rails-i18n' # Gives us default i18n for many languages
end
gem 'simplecov', :require => false, :group => :test
group :test do
  gem 'inherited_resources'
  gem 'sass-rails'
  gem 'rspec-mocks'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '1.0.0'
  gem 'launchy'
  gem 'jslint_on_rails',    '~> 1.0.6'
  gem 'guard-rspec'
  gem "guard-coffeescript"
  gem 'jasmine'
end
