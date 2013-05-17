class GeneratePeriods < ActiveRecord::Migration
  def up
    # generate periods from events in database
    
    periods.each do |gPeriod|
      period = Period.new
      period.punch_in  = gPeriod[:in_id]
      period.punch_out = gPeriod[:out_id]
      period.length = gPeriod[:length]
      period.employee = gPeriod[:employee]
      period.job = gPeriod[:job]
      period.save
    end
  end

  def down
    Period.delete_all
  end
  
  def periods
    rows = Array.new
    Employee.all.each do |employee| # loop though employees
      events = employee.events.order :punchtime
      rows.push Hash.new if events.count > 0
      events.each do |event| # loop though events (events are in clock order)
        if event.punch_type == "IN" || event.punch_type == 'OUT' then
  
          # rows.push Hash.new if ! rows.length == 0 || ! (rows.last.kind_of? Hash) || rows.last[:out]
          rows.push Hash.new if rows.last[:out]

  
          if rows.last[:in] then
            rows[-1][:out] = event.punchtime
            rows[-1][:out_id] = event;
            rows[-1][:length] = (rows.last[:out] - rows.last[:in])/3600 if rows.last[:out] > rows.last[:in]
          else
            rows[-1][:in] = event.punchtime
            rows[-1][:in_id] = event;
            rows[-1][:employee] = event.employee
          end
        end
  
        if rows.last[:job] then
          if event.job != rows.last[:job] then
            rows.push Hash.new
            rows[-1][:in] = event.punchtime
            rows[-1][:in_id] = event;
            rows[-1][:employee] = event.employee
          end
        end
        rows[-1][:job] = event.job
        rows[-1][:log] = (rows[-1][:log] || "" ) + (event.log + "\n" ) if event.log != nil
  
      end
    end
    rows.sort_by{|e| e[:in]}
  end
end
