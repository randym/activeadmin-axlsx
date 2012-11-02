require 'active_admin'
require 'active_admin/axlsx/autoload_extension'
require 'active_admin/axlsx/autoload_extension'
require 'active_admin/axlsx/builder'
require 'active_admin/axlsx/dsl'
require 'active_admin/axlsx/resource_extension'
require 'active_admin/axlsx/pagination_extension'
require 'active_admin/axlsx/resource_controller_extension'
require 'active_admin/axlsx/views_paginated_collection_extension'
require 'active_admin/axlsx/views_pages_index_extension'
class Railtie < ::Rails::Railtie
  config.after_initialize do
    if Mime::Type.lookup_by_extension(:xlsx).nil?
      begin
        # The mime type to be used in respond_to |format| style web-services in rails
        Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
      rescue NameError
        puts "Mime module not defined. Skipping registration of xlsx"
      end
    end
    ActiveAdmin.send :include, ActiveAdmin::Axlsx::AutoloadExtension
    ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Axlsx::DSL
    ActiveAdmin::Resource.send :include, ActiveAdmin::Axlsx::ResourceExtension
    ActiveAdmin::ResourceController.send :include, ActiveAdmin::Axlsx::ResourceControllerExtension
    ActiveAdmin::Views::Pages::Index.send :include, ActiveAdmin::Axlsx::ViewsPagesIndexExtension
    ActiveAdmin::Views::PaginatedCollection.add_format :xlsx
  end
end


