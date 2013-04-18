module ActiveAdmin
  module Axlsx
    module ResourceExtension
      def xlsx_builder=(builder)
        @xlsx_builder = builder
      end

      def xlsx_builder
        @xlsx_builder ||= ActiveAdmin::Axlsx::Builder.new(resource_class)
      end
    end
  end
end
