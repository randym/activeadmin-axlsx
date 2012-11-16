require 'spec_helper' 
include ActiveAdmin

module ActiveAdmin
  module Axlsx
    describe DSL do
      before { load_defaults! }

      let(:application){ ActiveAdmin::Application.new }
      let(:namespace){ Namespace.new(application, :admin) }
      context 'with a registered Category resource' do
        it 'registers the columns with the xlsx_builder' do
          @xlsx_config.xlsx_builder.columns.size.should == 1
          @xlsx_config.xlsx_builder.columns.index { |item| item.name == :block}.should == 0
        end

        it 'allows specification of the i18n scope' do
          @xlsx_config.xlsx_builder.i18n_scope.should == [:fishery]
        end

        it 'allows specification of header style attributes' do
          @xlsx_config.xlsx_builder.header_style[:sz].should == 14
        end

        it 'allows specification of column names to be ignored' do
          @xlsx_config.xlsx_builder.ignore_columns.should == [:id]
        end
      end
    end
  end
end

