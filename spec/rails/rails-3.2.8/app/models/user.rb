class User < ActiveRecord::Base
  has_many :posts, :foreign_key => 'author_id'
  attr_accessible :age, :first_name, :last_name, :type, :username
end
