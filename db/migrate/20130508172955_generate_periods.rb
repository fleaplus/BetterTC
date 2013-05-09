class GeneratePeriods < ActiveRecord::Migration
  def up
    # generate periods from events in database
    Employee.all.each do |employee|
      events = employee.events.order("punchtime ASC")
      period = Period.new
      
      events.each do |event|
        if event.punch_type == "IN" || event.punch_type == "OUT"
          
          # new period if current period already has a punch_out event
          if period.punch_out != nil
            period = Period.new
          end
          
          if event.punch_type == "IN"
            period.employee_id = event.employee_id
            period.job_id = event.job_id
            period.punch_in = event
          else event.punch_type == "OUT" && event.employee_id == period.employee_id && event.job_id == period.job_id
            period.punch_out = event
          end
          
          # calculate length if period has both a punch_in and punch_out event
          if period.punch_in && period.punch_out
            period.length = (period.punch_out.punchtime - period.punch_in.punchtime) / 3600
          end
          
          period.save!
        end
      end
    end
  end

  def down
    Period.delete_all
  end
end
