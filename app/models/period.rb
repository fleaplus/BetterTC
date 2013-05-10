class Period < ActiveRecord::Base
  belongs_to :employee
  belongs_to :job
  belongs_to :punch_in, class_name: 'Event', foreign_key: 'punch_in'
  belongs_to :punch_out, class_name: 'Event', foreign_key: 'punch_out'
  attr_accessible :length, :punch_in, :punch_out
  
  def generate_log
    completed_log = String.new
    completed_log << punch_in.log
    next_log_event = punch_in.log_event
    while next_log_event != nil
      completed_log << next_log_event.log
      next_log_event = next_log_event.log_event
    end
    completed_log << punch_out.log
    return completed_log
  end
end
