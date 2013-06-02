require 'rake'
require File.expand_path('../lib/active_admin/axlsx/version', __FILE__)
Gem::Specification.new do |s|
  s.name        = 'activeadmin-axlsx'
  s.version     = ActiveAdmin::Axlsx::VERSION
  s.author	    = "Randy Morgan"
  s.email       = 'digital.ipseity@gmail.com'
  s.homepage   	= 'https://github.com/randym/activeadmin-axlsx'
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.license     = 'MIT'
  s.summary     = "Adds excel downloads for resources within the Active Admin framework via Axlsx."
  s.description = <<-eof
  This gem uses axlsx to provide excel/xlsx downloads for resources in Active Admin. Often, users are happier with excel, so why not give it to them instead of CSV?
  eof
  s.files       = `git ls-files`.split("\n").sort 
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")
  s.test_files  = Dir.glob("{spec/**/*}")

  s.add_runtime_dependency 'activeadmin', "~> 0.6.0"
  s.add_runtime_dependency 'axlsx'

  s.required_ruby_version = '>= 1.9.2'
  s.require_path = 'lib'
end
