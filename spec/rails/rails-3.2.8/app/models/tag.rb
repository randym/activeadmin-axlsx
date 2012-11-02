class Tag < ActiveRecord::Base
  self.primary_key = :id
  before_create :set_id
  
  private
  def set_id
    self.id = 8.times.inject("") { |s,e| s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
  end
  attr_accessible :name
end
