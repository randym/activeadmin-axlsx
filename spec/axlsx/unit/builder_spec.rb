require 'spec_helper'

module ActiveAdmin
  module Axlsx
    describe Builder do

      let(:builder) { Builder.new(Post) }
      let(:content_columns) { Post.content_columns }

      context 'the default builder' do
        subject { builder }
        its(:header_style) { should == { :bg_color => '00', :fg_color => 'FF', :sz => 12, :alignment => { :horizontal => :center } } }
        its(:i18n_scope) { should be_nil }
        its("columns.size") { should == content_columns.size + 1 }
      end

      context 'customizing a builder' do
        it 'deletes columns we tell it we dont want' do
          builder.delete_columns :id, :body
          builder.columns.size.should == content_columns.size - 1
        end

        it 'lets us say we dont want the header' do
          builder.skip_header
          builder.instance_values["skip_header"].should be_true
        end

        it 'lets us add custom columns' do
          builder.column(:hoge)
          builder.columns.size.should == content_columns.size + 2
        end

        it 'lets us clear all columns' do
          builder.clear_columns
          builder.columns.size.should == 0
        end

        context 'Using Procs for delayed content generation' do

          let(:post) { Post.new(:title => "Hot Dawg") }

          before do
            builder.column(:hoge) { |resource| "#{resource.title} - with cheese" }
          end

          it 'stores the block when defining a column for later execution.' do
            builder.columns.last.data.should be_a(Proc)
          end

          it 'evaluates custom column blocks' do
            builder.columns.last.data.call(post).should == "Hot Dawg - with cheese"
          end
        end
      end

      context 'sheet generation without headers' do
        let!(:users) {  [User.new(first_name: 'bob', last_name: 'nancy')] }

        let!(:posts) {  [Post.new(title: 'bob', body: 'is a swell guy', author: users.first)] }

        let!(:builder) {
          Builder.new(Post, header_style: { sz: 10, fg_color: "FF0000" }, i18n_scope: [:axlsx, :post]) do
            skip_header
          end
        }

        before do
          User.stub!(:all) { users }
          Post.stub!(:all) { posts }
          # disable clean up so we can get the package.
          builder.stub(:clean_up) { false }
          builder.serialize(Post.all)
          @package = builder.send(:package)
          @collection = builder.collection
        end

        it 'does not serialize the header' do
          not_header = @package.workbook.worksheets.first.rows.first
          not_header.cells.first.value.should_not == 'Title'
        end
      end

      context 'whitelisted sheet generation' do
        let!(:users) {  [User.new(first_name: 'bob', last_name: 'nancy')] }

        let!(:posts) {  [Post.new(title: 'bob', body: 'is a swell guy', author: users.first)] }

        let!(:builder) {
          Builder.new(Post, header_style: { sz: 10, fg_color: "FF0000" }, i18n_scope: [:axlsx, :post]) do
            skip_header
            whitelist
            column :title
          end
        }

        before do
          User.stub!(:all) { users }
          Post.stub!(:all) { posts }
          # disable clean up so we can get the package.
          builder.stub(:clean_up) { false }
          builder.serialize(Post.all)
          @package = builder.send(:package)
          @collection = builder.collection
        end

        it 'does not serialize the header' do
          sheet = @package.workbook.worksheets.first
          sheet.rows.first.cells.size.should == 1
          sheet.rows.first.cells.first.value.should == @collection.first.title
        end
      end

      context 'Sheet generation with a highly customized configuration.' do

        let!(:users) {  [User.new(first_name: 'bob', last_name: 'nancy')] }

        let!(:posts) {  [Post.new(title: 'bob', body: 'is a swell guy', author: users.first)] }

        let!(:builder) {
          Builder.new(Post, header_style: { sz: 10, fg_color: "FF0000" }, i18n_scope: [:axlsx, :post]) do
            delete_columns :id, :created_at, :updated_at
            column(:author) { |resource| "#{resource.author.first_name} #{resource.author.last_name}" }
            after_filter { |sheet|
              sheet.add_row []
              sheet.add_row ['Author Name', 'Number of Posts']
              data = []
              labels = []
              User.all.each do |user|
                data << user.posts.size
                labels << "#{user.first_name} #{user.last_name}"
                sheet.add_row [labels.last, data.last]
              end
              chart_color =  %w(88F700 279CAC B2A200 FD66A3 F20062 C8BA2B 67E6F8 DFFDB9 FFE800 B6F0F8)
              sheet.add_chart(::Axlsx::Pie3DChart, :title => "post by author") do |chart|
                chart.add_series :data => data, :labels => labels, :colors => chart_color
                chart.start_at 4, 0
                chart.end_at 7, 20
              end
            }
            before_filter do |sheet|
              collection.first.author.first_name = 'Set In Proc'
              sheet.add_row ['Created', Time.zone.now]
              sheet.add_row []
            end
          end
        }

        before(:all) do
          User.stub!(:all) { users }
          Post.stub!(:all) { posts }
          # disable clean up so we can get the package.
          builder.stub(:clean_up) { false }
          builder.serialize(Post.all)
          @package = builder.send(:package)
          @collection = builder.collection
        end

        it 'provides the collection object' do
          @collection.count.should == Post.all.count
        end

        it 'merges our customizations with the default header style' do
          builder.header_style[:sz].should be(10)
          builder.header_style[:fg_color].should == 'FF0000'
          builder.header_style[:bg_color].should == '00'
        end

        it 'uses the specified i18n_scope' do
          builder.i18n_scope.should == [:axlsx, :post]
        end

        it 'translates the header row based on our i18n scope' do
          header_row = @package.workbook.worksheets.first.rows[2]
          header_row.cells.map(&:value).should == ['Title', 'Content', 'Published On', 'Publisher']
        end

        it 'processes the before filter' do
          @package.workbook.worksheets.first["A1"].value.should == 'Created'
        end

        it 'lets us work against the collection in the before filter' do
          @package.workbook.worksheets.first.rows.last.cells.first.value.should == 'Set In Proc nancy'
        end

        it 'processes the after filter' do
          @package.workbook.charts.size.should == 1
        end

        it 'has no OOXML validation errors' do
          @package.validate.size.should ==  0
        end
      end
    end
  end
end
