class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.order("punchtime DESC").page(params[:page]).per(10)
    @events = @events.where :employee_id => params[:employee_id] if params[:employee_id]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new



    @event = Event.new
    @jobs = Job.where({:active => true})
    @users = Employee.order(:lastname)
    @types = ['IN','OUT','LOG']
    @lastevent = Event.where({:employee_id => params[:employee_id]}).last || Event.last


    begin
      @lastevent.employee_id = params[:employee_id] || nil 
      
    rescue Exception => e
      @lastevent = Event.new
      @lastevent.employee_id = params[:employee_id] || nil
    end
    if params[:job_id] then @event.job_id = params[:job_id] 
    elsif @lastevent then @event.job_id = @lastevent.job_id
    else @event.job_id = nil
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @lastevent = @event
    @jobs = Job.where({:active => true})
    @users = Employee.order(:firstname)
    @types = ['IN','OUT','LOG']
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    # @event.employee_id = params[:employee_id]
    # @event.job_id = params[:job_id]

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def periods
    rows = Array.new
    Employee.all.each do |employee| # loop though employees
      events = employee.events.order :punchtime
      rows.push Hash.new if events.count > 0
      events.each do |event| # loop though events (events are in clock order)
        if event.punch_type == "IN" || event.punch_type == 'OUT' then

          rows.push Hash.new if ! rows.length == 0 || ! (rows.last.kind_of? Hash) || rows.last[:out]

          if rows.last[:in] then
            rows[-1][:out] = event.punchtime
            rows[-1][:length] = (rows.last[:out] - rows.last[:in])/3600 if rows.last[:out] > rows.last[:in] 
          else
            rows[-1][:in] = event.punchtime
            rows[-1][:employee] = event.employee
          end
        end

        if rows.last[:job] then
          if event.job != rows.last[:job] then
            rows.push Hash.new
            rows[-1][:in] = event.punchtime
            rows[-1][:employee] = event.employee
          end
        end
        rows[-1][:job] = event.job 
        rows[-1][:log] = (rows[-1][:log] || "" ) + (event.log + "\n" ) if event.log != nil

      end
    end
    rows.sort_by{|e| e[:in]}
  end


  # Report view
  # GET /events/report
  def report
    @events = Event.order :punchtime
    @events = @events.where :employee_id => params[:employee_id] if params[:employee_id]
    @events = @events.where :job_id => params[:job_id] if params[:job_id]

    @jobs = Job.where({:active => true})
    @employees = Employee.order(:lastname)

    @periods = periods

    respond_to do |format|
      format.html # report.html.erb
      format.json { render json: periods }
    end
  end
    # Report for Watermill view
  # GET /events/report_watermill
  def report_watermill
    @events = Event.order :punchtime
    @events = @events.where :employee_id => params[:employee_id] if params[:employee_id]
    @events = @events.where :job_id => params[:job_id] if params[:job_id]

    @jobs = Job.where({:active => true})
    @employees = Employee.order(:lastname)

    @periods = periods

    respond_to do |format|
      format.html # report.html.erb
      format.json { render json: periods }
    end
  end

end