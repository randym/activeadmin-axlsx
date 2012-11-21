require 'spec_helper' 
include ActiveAdmin

module ActiveAdmin
  module Axlsx
    describe Resource do
      let(:resource) { ActiveAdmin.register(Post) }

      let(:custom_builder) do
        Builder.new(Post) do |builder|
          column(:fake) { :fake }
        end
      end

      context 'when registered' do
        it "each resource has an xlsx_builer" do
          resource.xlsx_builder.should be_a(Builder)
        end

        it "We can specify our own configured builder" do
          lambda { resource.xlsx_builder = custom_builder }.should_not raise_error
        end
      end
    end
  end
end
