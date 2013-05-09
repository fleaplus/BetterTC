class Period < ActiveRecord::Base
  belongs_to :employee
  belongs_to :job
  belongs_to :punch_in, class_name: 'Event', foreign_key: 'punch_in'
  belongs_to :punch_out, class_name: 'Event', foreign_key: 'punch_out'
  attr_accessible :length, :punch_in, :punch_out
end
