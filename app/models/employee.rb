class Employee < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :username
  has_many :events
end
