require 'spec_helper'

module ActiveAdmin
  module Axlsx
    describe ::ActiveAdmin::ResourceDSL do
      context 'in a registraiton block' do
        let(:builder) {
          config = ActiveAdmin.register(Post) do
            xlsx(i18n_scope: [:rspec], header_style: { sz: 20 }) do
              delete_columns :id, :created_at
              column(:author) { |post| post.author.first_name }
              before_filter { |sheet| sheet.add_row ['before_filter'] }
              after_filter { |sheet| sheet.add_row['after_filter'] }
              skip_header
            end
          end
          config.xlsx_builder
        }


        it "uses our customized i18n scope" do
          builder.i18n_scope.should == [:rspec]
        end

        it "removed the columns we told it to ignore" do
          [:id, :create_at].each do |removed|
            builder.columns.index{|column| column.name == removed}.should be_nil
          end
        end

        it "added the columns we declared" do
          builder.columns.index{ |column| column.name == :author}.should_not be_nil
        end

        it "has a before filter set" do
          builder.instance_values["before_filter"].should be_a(Proc)
        end
        it "has an after filter set" do
          builder.instance_values["after_filter"].should be_a(Proc)
        end

        it "indicates that the header should be excluded" do
          builder.instance_values['skip_header'].should be_true
        end

        it "updates the header style" do
          builder.header_style[:sz].should be(20)
        end
      end
    end
  end
end
