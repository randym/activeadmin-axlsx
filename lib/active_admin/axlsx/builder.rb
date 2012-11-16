require 'axlsx'

module ActiveAdmin
  module Axlsx
    # Builder extends CSVBuilder adding in xlsx specific options
    #
    # Usage example
    #
    #   xlsx_builder = ActiveAdmin::Axlsx::Builder.new
    #   xlsx_builder.column :id
    #   xlsx_builder.column('Name') { |resource| resource.full_name }
    #
    #   xlsx_builder = ActiveAdmin::Axlsx::Builder.new :shared_strings => true
    #   xlsx_builder.column :id
    #
    #   xlsx_builder = ActiveAdmin::Axlsx::Builer.new :header_style => { :bg_color => '00', :fg_color => 'FF', :sz => 14, :alignment => { :horizontal => :center } }
    #   xlsx_buider.i18n_scope [:active_record, :models, :posts]
    class Builder < ActiveAdmin::CSVBuilder

      include MethodOrProcHelper

      @@default_header_style =  { :bg_color => '00', :fg_color => 'FF', :sz => 12, :alignment => { :horizontal => :center } }

      # Return a default XlsxBuilder for a resource
      # The XlsxBuilder columns will be id, follwed by this resource's content columns
      # The default header_style is applied.
      def self.default_for_resource(resource)
        xlsx_builder = super
        xlsx_builder.header_style = @@default_header_style
        xlsx_builder
      end

      # when this is set to true the xlsx file will be generated with
      # shared strings and will inter-operate with Numbers for Mac
      # This is true by default, but you can set it to false to minimize the generation time.
      attr_accessor :shared_strings

      # This has can be used to override the default header style for your
      # sheet.
      # @see https://github.com/randym/axlsx for more details on how to
      # create and apply style.
      # @return [Hash]
      attr_accessor :header_style

      # This is the I18n scope that will be used when looking up your
      # colum names in the current I18n locale.
      # If you set it to [:active_admin, :resources, :posts] the 
      # serializer will render the value at active_admin.resources.posts.title in the
      # current translations
      # @note If you do not set this, the column name will be titleized.
      attr_accessor :i18n_scope

      # @param [Hash] options the options for this builder
      # @option [Hash] :header_style - a hash of style properties to apply
      #   to the header row
      # @option [Array] :i18n_scope - the I18n scope to use when looking
      #   up localized column headers.
      # @option [Boolean] :shared_strings - Tells the serializer to use
      # shared strings or not when parsing out the package. 
      # @note shared strings are an optional part of the ECMA-376 spec,and
      # are only required when you need to support Numbers.
      def initialize(options={}, &block)
        @ignore_columns = []
        @columns = []
        @header_style = @@default_header_style.merge(options.delete(:header_style) || {})
        @i18n_scope = options.delete(:i18n_scope) || []
        @shared_strings = options.delete(:shared_strings) || true
        instance_eval &block if block_given?
      end
      # Serializes the collection provided
      # @return [Axlsx::Package]
      def serialize(collection)
        finalize_columns(collection)
        package.workbook.add_worksheet do |sheet|
          sheet.add_row header_row, :style => header_style_id
          collection.each do |resource|
            sheet.add_row @columns.map { |column| call_method_or_proc_on resource, column.data }
          end
          @after_filter.call(sheet)
        end
        package
      end

      def after_filter(&block)
        @after_filter = block
      end

      # Add a column
      def column(name, &block)
        @columns << Column.new(name, block)
      end

      # Tells the serializer which columns to ignore during serialization
      # each column_name should be a symbol
      def ignore_columns(*column_names)
        @ignore_columns += column_names
      end

      protected

      class Column
        attr_reader :name, :data

        def initialize(name, block = nil)
          @name = name.to_sym
          @data = block || @name
        end

        def localized_name(i18n_scope = nil)
          return name.to_s.titleize unless i18n_scope
          I18n.t name, i18n_scope
        end
      end

      private

      # the Axlsx::Package
      def package
        @package ||= ::Axlsx::Package.new(:use_shared_strings => shared_strings)
      end

      # tranform column names into array of localized strings
      # @return [Array]
      def header_row
        columns.map { |column| column.localized_name(i18n_scope) }
      end

      def header_style_id
        package.workbook.styles.add_style header_style
      end

      def finalize_columns_for_resource(collection)
        (resource_columns(collection) && @columns).delete_if do |column|
          @remove_columns.include? column.name
        end
      end

      def resource_columns(resource)
        @resource_columns ||= resource.content_columns.each do |content_column|
          @coumns << Column.new(content_column.name.to_sym)
        end.shift(Column.new :id)
      end

    end
  end
end
