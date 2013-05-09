class Event < ActiveRecord::Base
  belongs_to :employee
  belongs_to :job
  has_many :periods
  attr_accessible :log, :punchtime, :punch_type, :job_id, :employee_id, :punch_date, :punch_time

  attr_accessor :punch_date, :punch_time

  # add some callbacks
  after_initialize :get_datetimes # convert db format to accessors
  before_validation :set_datetimes # convert accessors back to db format

  def get_datetimes
    self.punchtime ||= Time.now  # if the punchtime time is not set, set it to now

    self.punch_date ||= self.punchtime.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
    self.punch_time ||= "#{'%02d' % self.punchtime.hour}:#{'%02d' % self.punchtime.min}" # extract the time
  end

  def set_datetimes
    self.punchtime = "#{self.punch_date} #{self.punch_time}:00" # convert the two fields back to db
  end  

  validates_format_of :punch_time, :with => /\d{1,2}:\d{2}/

end
