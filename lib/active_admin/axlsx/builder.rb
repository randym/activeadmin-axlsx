require 'axlsx'

module ActiveAdmin
  module Axlsx
    # Builder for xlsx data using the axlsx gem.
    class Builder

      include MethodOrProcHelper

      # @param resource_class The resource this builder generate column information for.
      # @param [Hash] options the options for this builder
      # @option [Hash] :header_style - a hash of style properties to apply
      #   to the header row. Any properties specified will be merged with the default
      #   header styles. @see Axlsx::Styles#add_style
      # @option [Array] :i18n_scope - the I18n scope to use when looking
      #   up localized column headers.
      # @param [Block] Any block given will evaluated against this instance of Builder.
      #   That means you can call any method on the builder from withing that block.
      # @example
      #   ActiveAdmin::Axlsx:Builder.new(Post, i18n: [:axlsx]) do
      #     delete_columns :id, :created_at, :updated_at
      #     column(:author_name) { |post| post.author.name }
      #     column(:
      #     after_filter { |sheet|
      #       sheet.add_row []
      #
      #       sheet.add_row ['Author Name', 'Number of Posts'], :style => self.header_style
      #       data = labels = []
      #       User.all.each do |user|
      #         data << [user.posts.size]
      #         labels << user.name
      #         sheet.add_row [labels.last, data.last]
      #       end
      #       chart_color =  %w(88F700, 279CAC, B2A200, FD66A3, F20062, C8BA2B, 67E6F8, DFFDB9, FFE800, B6F0F8)
      #       sheet.add_chart(Axlsx::Pie3DChart, :title => "post by author") do |chart|
      #         chart.add_series :data => data, :labels => labels, :colors => chart_color
      #         chart.start_at 2, sheet.rows.size
      #         chart.end_at 3, sheet.rows.size + 20
      #       end
      #     }
      #   end
      #   @see ActiveAdmin::Axlsx::DSL
      def initialize(resource_class, options={}, &block)
        @skip_header = false
        @columns = resource_columns(resource_class)
        parse_options options
        instance_eval &block if block_given?
      end

      # The default header style
      # @return [Hash]
      def header_style
        @header_style ||= { :bg_color => '00', :fg_color => 'FF', :sz => 12, :alignment => { :horizontal => :center } }
      end

      # This has can be used to override the default header style for your
      # sheet. Any values you provide will be merged with the default styles.
      # Precidence is given to your hash
      # @see https://github.com/randym/axlsx for more details on how to
      # create and apply style.
      def header_style=(style_hash)
        @header_style = header_style.merge(style_hash)
      end

      # Indicates that we do not want to serialize the column headers
      def skip_header
        @skip_header = true
      end

      # The scope to use when looking up column names to generate the report header
      def i18n_scope
        @i18n_scope ||= nil
      end

      # This is the I18n scope that will be used when looking up your
      # colum names in the current I18n locale.
      # If you set it to [:active_admin, :resources, :posts] the 
      # serializer will render the value at active_admin.resources.posts.title in the
      # current translations
      # @note If you do not set this, the column name will be titleized.
      def i18n_scope=(scope)
        @i18n_scope = scope
      end

      # The stored block that will be executed after your report is generated.
      def after_filter(&block)
        @after_filter = block
      end

      # the stored block that will be executed before your report is generated.
      def before_filter(&block)
        @before_filter = block
      end

      # The columns this builder will be serializing
      attr_reader :columns

      # The collection we are serializing.
      # @note This is only available after serialize has been called,
      # and is reset on each subsequent call.
      attr_reader :collection

      # removes all columns from the builder. This is useful when you want to
      # only render specific columns. To remove specific columns use ignore_column.
      def clear_columns
        @columns = []
      end

      # Clears the default columns array so you can whitelist only the columns you
      # want to export
      def whitelist
        @columns = []
      end

      # Add a column
      # @param [Symbol] name The name of the column.
      # @param [Proc] block A block of code that is executed on the resource
      #                     when generating row data for this column.
      def column(name, &block)
        @columns << Column.new(name, block)
      end

      # removes columns by name
      # each column_name should be a symbol
      def delete_columns(*column_names)
        @columns.delete_if { |column| column_names.include?(column.name) }
      end

      # Serializes the collection provided
      # @return [Axlsx::Package]
      def serialize(collection)
        @collection = collection
        apply_filter @before_filter
        export_collection(collection)
        apply_filter @after_filter
        to_stream
      end

      protected

      class Column

        def initialize(name, block = nil)
          @name = name.to_sym
          @data = block || @name
        end

        attr_reader :name, :data

        def localized_name(i18n_scope = nil)
          return name.to_s.titleize unless i18n_scope
          I18n.t name, scope: i18n_scope
        end
      end

      private

      def to_stream
        stream = package.to_stream.read
        clean_up
        stream
      end

      def clean_up
        @package = @sheet = nil
      end

      def export_collection(collection)
        header_row(collection) unless @skip_header
        collection.each do |resource|
          sheet.add_row resource_data(resource)
        end
      end

      # tranform column names into array of localized strings
      # @return [Array]
      def header_row(collection)
        sheet.add_row header_data_for(collection), { :style => header_style_id }
      end

      def header_data_for(collection)
        resource = collection.first
        columns.map do |column|
          column.localized_name(i18n_scope) if in_scope(resource, column)
        end.compact
      end

      def apply_filter(filter)
        filter.call(sheet) if filter
      end

      def parse_options(options)
        options.each do |key, value|
          self.send("#{key}=", value) if self.respond_to?("#{key}=") && value != nil
        end
      end

      def resource_data(resource)
        columns.map  do |column|
          call_method_or_proc_on resource, column.data if in_scope(resource, column)
        end
      end

      def in_scope(resource, column)
        return true unless column.name.is_a?(Symbol)
        resource.respond_to?(column.name)
      end

      def sheet
        @sheet ||= package.workbook.add_worksheet
      end

      def package
        @package ||= ::Axlsx::Package.new(:use_shared_strings => true)
      end

      def header_style_id
        package.workbook.styles.add_style header_style
      end

      def resource_columns(resource)
        [Column.new(:id)] + resource.content_columns.map do |column|
          Column.new(column.name.to_sym)
        end
      end
    end
  end
end
