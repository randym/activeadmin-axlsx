require 'spec_helper'
describe ActiveAdmin::ResourceController do

  let(:mime) { Mime::Type.lookup_by_extension(:xlsx) }

  let(:request) do
    ActionController::TestRequest.new.tap do |test_request|
      test_request.accept = mime
    end
  end

  let(:response) { ActionController::TestResponse.new }

  let(:controller) do
    Admin::CategoriesController.new.tap do |controller|
      controller.request = request
      controller.response = response
    end
  end

  let(:filename) { "#{controller.resource_class.to_s.downcase.pluralize}-#{Time.now.strftime("%Y-%m-%d")}.xlsx" }

  it 'generates an xlsx filename' do
    controller.xlsx_filename.should == filename
  end

  context 'when making requests with the xlsx mime type' do
     it 'returns xlsx attachment when requested' do
      controller.send :index
      response.headers["Content-Disposition"].should == "attachment; filename=\"#{filename}\""
      response.headers["Content-Transfer-Encoding"].should == 'binary'
    end

    it 'returns max_per_page for per_page' do
      controller.send(:per_page).should == controller.send(:max_per_page)
    end

    it 'kicks back to the default per_page when we are not specifying a xlsx mime type' do
      controller.request.accept = 'text/html'
      controller.send(:per_page).should == ActiveAdmin.application.default_per_page
    end
  end
end

