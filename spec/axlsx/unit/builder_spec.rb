require 'spec_helper'
module ActiveAdmin
  module Axlsx
    describe Builder do

      context "serialization" do
        #need to find some way of getting some data 
        ActiveAdmin::GetMeSomeShit!
      end

      context "with shared strings" do
        let(:builder) do
          Builder.new :shared_strings => true
        end

        it "should be set to use shared strings" do 
          builder.shared_strings.should be_true
        end
      end

      context "with i18n_scope" do
        let(:builder) do
          Builder.new :i18n_scope => [:active_admin, :resource, :category]
        end

        it "should have the defined i18n_scope set" do
          builder.i18n_scope.should == [:active_admin, :resource, :category]
        end
      end

      context "with a customized header style" do
        let (:header_style) do
          { :bg_color => '00', :fg_color => 'FF', :sz => 12, :alignment => { :horizontal=> :center } }
        end

        let (:builder) do
          Builder.new :header_style => header_style
        end

        it "should be set up with a header style" do
          header_style.each { |key , value| builder.header_style[key].should == value }
        end
      end
    end
  end
end
