begin
  # The mime type to be used in respond_to |format| style web-services in rails
  Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
rescue NameError
  puts "Mime module not defined. Skipping registration of xlsx"
end

require 'active_admin'
require 'active_admin/axlsx/autoload_extension'
require 'active_admin/axlsx/autoload_extension'
require 'active_admin/axlsx/builder'
require 'active_admin/axlsx/dsl'
require 'active_admin/axlsx/resource_extension'
require 'active_admin/axlsx/pagination_extension'
require 'active_admin/axlsx/resource_controller_extension'

# Which is better?!?
ActiveAdmin.send :include, ActiveAdmin::Axlsx::AutoloadExtension
#module ActiveAdmin
#  autoload :XlsxBuilder,              'active_admin/xlsx/xlsx_builder'
#end

# Add Extensions
ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Axlsx::DSL
ActiveAdmin::Resource.send :include, ActiveAdmin::Axlsx::ResourceExtension

# BOOOOOM
#ActiveAdmin::ResourceController.send :include, ActiveAdmin::Axlsx::ResourceControllerExtension
