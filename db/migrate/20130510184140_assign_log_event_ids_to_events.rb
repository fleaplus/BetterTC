class AssignLogEventIdsToEvents < ActiveRecord::Migration
  def up
    Employee.all.each do |employee|
      events = employee.events.order("punchtime DESC")
      
      # loop through events starting at the most recent
      events.each do |event|
        if event.punch_type == "LOG"
          # find previous event for this job
          last_event = events.where("punchtime < ? AND job_id = ?", event.punchtime, event.job_id).limit(1).first
          if last_event.punch_type == "IN" || last_event.punch_type == "LOG"
            last_event.log_event_id = event.id
            last_event.save!
          end
        end
      end
    end
  end

  def down
  end
end
