module ActiveAdmin
  module Axlsx
    module ResourceControllerExtension
      def self.included(base)
        # TEST THIS
        base.send :respond_to, :xlsx
      end

      # THIS IS WRONG
      # I dont want to be redefining the method.
      # ActiveAdmin needs to maintain a list of renders. something like
      # ActiveAdmin.add_renderer action, format, Proc/Block
      # and either metaprogram out the actions or check the list of
      # plugin_renderers on every request.
      #
      def index(options={}, &block)
        super(options) do |format|
          block.call(format) if block
          format.html { render active_admin_template('index') }
          format.csv do
            headers['Content-Type'] = 'text/csv; charset=utf-8'
            headers['Content-Disposition'] = %{attachment; filename="#{csv_filename}"}
            render active_admin_template('index')
          end
          format.xlsx do
            xlsx = active_admin_config.xlsx_builder.serialize(collection)
            send_data xlsx.to_stream.read, :filename => "#{xlsx_filename}", :type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" 
          end
        end
      end 

      protected
      # Returns a filename for the xlsx file using the collection_name
      # and current date such as 'my-articles-2011-06-24.xlsx'.
      def xlsx_filename
        "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.xlsx"
      end
    end
  end
end
