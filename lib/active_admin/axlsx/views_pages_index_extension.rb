module ActiveAdmin
  module Axlsx
    module ViewsPagesIndexExtension
      # TODO: Refactor to new HTML DSL
      def build_download_format_links(formats = [:xlsx, :csv, :xml, :json])
        links = formats.collect do |format|
          link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format))
        end
        text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
      end
    end
  end
end
