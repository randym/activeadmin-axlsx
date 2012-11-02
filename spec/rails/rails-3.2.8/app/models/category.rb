class Category < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts
  attr_accessible :description, :name
end
