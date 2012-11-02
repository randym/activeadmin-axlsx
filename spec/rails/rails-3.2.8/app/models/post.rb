class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :category
  accepts_nested_attributes_for :author
  attr_accessible :author_id, :body, :category_id, :published_at, :title
  attr_accessible :author
end
