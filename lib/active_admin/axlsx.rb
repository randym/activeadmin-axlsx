require 'active_admin'
require 'active_admin/axlsx/build_download_format_links'
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

    ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Axlsx::DSL
    ActiveAdmin::Resource.send :include, ActiveAdmin::Axlsx::ResourceExtension
    ActiveAdmin::ResourceController.send :include, ActiveAdmin::Axlsx::ResourceControllerExtension
    # TODO remove < 0.5.1 block once active admin has released.
    # Pull request to fix build download format links has already been merged into active admin.
    if ActiveAdmin::VERSION < '0.5.1'
      ActiveAdmin::Views::PaginatedCollection.send :include, ActiveAdmin::Axlsx::BuildDownloadFormatLinks
      ActiveAdmin::Views::Pages::Index.send :include, ActiveAdmin::Axlsx::BuildDownloadFormatLinks
    else
      ActiveAdmin::Views::PaginatedCollection.add_format :xlsx
    end
  end
end


