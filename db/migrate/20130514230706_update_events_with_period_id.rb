class UpdateEventsWithPeriodId < ActiveRecord::Migration
  # def up
  #     Event.all.each do |event|
  #       period = Period.where(["periods.employee_id = ? AND periods.job_id = ? AND periods.punch_in = ? OR periods.punch_out = ?", event.employee_id, event.job_id, event.id, event.id]).first
  #       if period
  #         if event.id != period.punch_in || event.id != period.punch_out
  #           Event.create employee_id: event.employee_id, punch_type: "OUT", punchtime: event.punchtime, log: event.log, job_id: event.job_id, period_id: period.id
  #           next
  #         end
  #         event.period_id = period.id
  #         event.save!
  #       end
  #     end
  #   end
  
  def up
    Period.all.each do |period|
      punch_in_event = Event.find(period.punch_in)

      if punch_in_event != nil
        # find all periods that reference this event
        event_periods = Period.where(["periods.punch_in = ? OR periods.punch_out = ?", punch_in_event.id, punch_in_event.id])
        if event_periods.count == 1 # only referenced once, copy this period's id into the event
          punch_in_event.period_id = period.id
          punch_in_event.save!
        else # referenced more than once
          # was this event a missed out punch?
          event_periods.all.each do |p|
            e_i = Event.find(p.punch_in)
            if e_i == punch_in_event && e_i.punch_type == "IN"
              # this punch was the correct one, enter it without modification
              e_i.period_id = p.id
              e_i.save!
            end
            next if p.punch_out == nil # this event is null, move on to next one
            e_o = Event.find(p.punch_out)
            if e_o == punch_in_event && e_o.punch_type == "IN"
              # create a new event for this missed punch
              new_event = Event.create( employee_id: e_o.employee_id,
                                        punch_type: "OUT",
                                        punchtime: e_o.punchtime,
                                        log: e_o.log,
                                        job_id: e_o.job_id,
                                        period_id: p.id )
              # update period to reflect new event that we created
              p.punch_out = new_event
              p.save!
            end
          end
        end
      end
      
      next if period.punch_out == nil # this event is null, move on to the next one
      punch_out_event = Event.find(period.punch_out)

      if punch_out_event != nil
        # find all periods that reference this event
        event_periods = Period.where(["periods.punch_in = ? OR periods.punch_out = ?", punch_out_event.id, punch_out_event.id])
        if event_periods.count == 1 # only referenced once, copy this period's id into the event
          punch_out_event.period_id = period.id
          punch_out_event.save!
        # else # referenced more than once
        #           # was this event a missed out punch?
        #           event_periods.all.each do |p|
        #             e_i = Event.find(p.punch_in)
        #             if e_i == punch_in_event && e_i.punch_type == "IN"
        #               # this punch was the correct one, enter it without modification
        #               e_i.period_id = p.id
        #               e_i.save!
        #             end
        #             next if p.punch_out == nil # this event is null, move on to next one
        #             e_o = Event.find(p.punch_out)
        #             if e_o == punch_in_event && e_o.punch_type == "IN"
        #               # create a new event for this missed punch
        #               new_event = Event.create( employee_id: e_o.employee_id,
        #                                         punch_type: "OUT",
        #                                         punchtime: e_o.punchtime,
        #                                         log: e_o.log,
        #                                         job_id: e_o.job_id,
        #                                         period_id: p.id )
        #               # update period to reflect new event that we created
        #               p.punch_out = new_event
        #               p.save!
        #             end
        #           end
        end
      end
    end
  end

  def down
  end
end
