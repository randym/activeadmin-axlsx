module ActiveAdmin
  module Axlsx
    module BuildDownloadFormatLinks
      def self.included(base)
        base.send :alias_method_chain, :build_download_format_links, :xlsx
      end

      # We are patching the build_download_format_links to include the :xlsx format
      # Once ActiveAdmin 0.5.1 or higher has been released this can and should be removed.
      def build_download_format_links_with_xlsx(formats = [:csv, :xml, :json, :xlsx])
        build_download_format_links_without_xlsx(formats)
      end
    end
  end
end
