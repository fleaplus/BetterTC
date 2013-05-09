class Job < ActiveRecord::Base
  attr_accessible :active, :name, :hours
  has_many :events
  has_many :periods
  attr_accessor :hours 
end
