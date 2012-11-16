module ActiveAdmin
  module Axlsx
    module DSL
      # Configure the xlsx format
      #
      # For example:
      #
      #   xlsx do
      #     i18n_scope = [:active_admin, :resources, :post]
      #     column :name
      #     column(:author) { |post| post.author.full_name }
      #   end
      #
      #   xlsx :header_style => { :bg_color => "00", :fg_color => "FF" } do
      #     column :name
      #   end
      def xlsx(options={}, &block)
        config.xlsx_builder = ActiveAdmin::Axlsx::Builder.new(options, &block)
      end

    end
  end
end

