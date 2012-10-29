module ActiveAdmin
  module Axlsx
    module ResourceExtension

      def xlsx_builder=(builder)
        @xlsx_builder = builder
      end

      def xlsx_builder
        @xlsx_builder ||= default_xlsx_builder
      end

      private

      def default_xlsx_builder
        @default_xlsx_builder ||= Axlsx::Builder.default_for_resource(resource_class)
      end
    end
  end
end
