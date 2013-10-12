require 'active_admin'
require 'active_admin/axlsx/version'
require 'active_admin/axlsx/builder'
require 'active_admin/axlsx/dsl'
require 'active_admin/axlsx/resource_extension'
require 'active_admin/axlsx/resource_controller_extension'

class Railtie < ::Rails::Railtie
  config.before_initialize do
    begin
      if Mime::Type.lookup_by_extension(:xlsx).nil?
        # The mime type to be used in respond_to |format| style web-services in rails
        Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
      end
    rescue NameError
      # noop
    end

  end

  config.after_initialize do
    ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Axlsx::DSL
    ActiveAdmin::Resource.send :include, ActiveAdmin::Axlsx::ResourceExtension
    ActiveAdmin::Views::PaginatedCollection.add_format :xlsx
    ActiveAdmin::ResourceController.send :include, ActiveAdmin::Axlsx::ResourceControllerExtension
  end
end


