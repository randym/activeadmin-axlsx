module ActiveAdmin
  module Axlsx
    module ResourceControllerExtension
      def self.included(base)
        base.send :alias_method_chain, :per_page, :xlsx
        base.send :alias_method_chain, :index, :xlsx
        base.send :respond_to, :xlsx
      end

      def index_with_xlsx(options={}, &block)
        index_without_xlsx(options) do |format|
           format.xlsx do
            xlsx = active_admin_config.xlsx_builder.serialize(collection)
            send_data xlsx.to_stream.read, :filename => "#{xlsx_filename}", :type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" 
          end
        end
      end

      def per_page_with_xlsx
          if request.format == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            return max_csv_records
          end
          per_page_without_xlsx
      end

      # Returns a filename for the xlsx file using the collection_name
      # and current date such as 'my-articles-2011-06-24.xlsx'.
      def xlsx_filename
        "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.xlsx"
      end
    end
  end
end
