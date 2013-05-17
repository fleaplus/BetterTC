class Period < ActiveRecord::Base
  belongs_to :employee
  belongs_to :job
  belongs_to :punch_in, class_name: 'Event', foreign_key: 'punch_in'
  belongs_to :punch_out, class_name: 'Event', foreign_key: 'punch_out'
  has_many :events
  attr_accessible :length, :punch_in, :punch_out
  
  def find_events
    @events ||= Event.where("events.period_id = ?", self.id).order(:punchtime)
    return @events
  end
  
  def get_length
    events = find_events
    return (events.last.punchtime - events.first.punchtime) / 3600
  end
end
