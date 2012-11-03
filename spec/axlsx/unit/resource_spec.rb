require 'spec_helper' 
include ActiveAdmin

module ActiveAdmin
  module Axlsx
    describe Resource do
      before { load_defaults! }

      let(:application){ ActiveAdmin::Application.new }
      let(:namespace){ Namespace.new(application, :admin) }

      def config(options = {})
        @config ||= Resource.new(namespace, Category, options)
      end

      describe "#xlsx_builder" do
        context "when no xlsx_builder set" do
          it "should return a default xlsx_builder with id and content columns" do
            config.xlsx_builder.columns.size.should == Category.content_columns.size + 1
          end
        end

        context "when xslx_builder set" do
          it "should return the xlsx_builder we set" do
            xlsx_builder = Builder.new
            config.xlsx_builder = xlsx_builder
            config.xlsx_builder.should == xlsx_builder
          end
        end
      end

    end
  end
end
