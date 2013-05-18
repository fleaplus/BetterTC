class PeriodsController < ApplicationController
  # GET /periods
  # GET /periods.json
  def index
    @events = Event.order :punchtime
    @events = @events.where :employee_id => params[:employee_id] if params[:employee_id]
    @events = @events.where :job_id => params[:job_id] if params[:job_id]
    
    @jobs = Job.where({:active => true})
    @employees = Employee.order(:lastname)
    
    @start_date = DateTime.now.beginning_of_week
    @end_date = DateTime.now.end_of_week
    if params[:daterange]
      case
      when params[:daterange] == "lastweek"
        @start_date = 7.days.ago.beginning_of_week.to_datetime; @end_date = Date.today.beginning_of_week.to_datetime
      when params[:daterange] == "today"
        @start_date = DateTime.now; @end_date = 1.day.from_now.to_datetime
      when params[:daterange] == "lastmonth"
        @start_date = 1.month.ago.beginning_of_month.to_datetime; @end_date = DateTime.now.beginning_of_month
      when params[:daterange] == "thismonth"
        @start_date = DateTime.now.beginning_of_month.to_datetime; @end_date = DateTime.now.end_of_month
      when params[:daterange] == "thisyear"
        @start_date = DateTime.now.beginning_of_year; @end_date = DateTime.now.end_of_year
      when params[:daterange] == "lastyear"
        @start_date = 1.year.ago.beginning_of_year.to_datetime; @end_date = 1.year.ago.end_of_year.to_datetime
      when params[:daterange] == "custom"
        @start_date = Time.zone.parse(params[:startdate]); @end_date = Time.zone.parse(params[:enddate])
      end
    end
    
    @adj_start_time = @start_date.utc;
    @adj_end_time = @end_date.utc;
    
    @periods = Period.joins(:events).where("events.punchtime" => @start_date.utc..@end_date.utc).group('periods.id')
    @periods_query = @periods.to_sql;
    @period_length_total = @periods.to_a.sum { |period| period.get_length }
    @periods = @periods.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @periods }
    end
  end

  # GET /periods/1
  # GET /periods/1.json
  def show
    @period = Period.find(params[:id])
    @events = @period.find_events

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @period }
    end
  end

  # GET /periods/new
  # GET /periods/new.json
  def new
    @period = Period.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @period }
    end
  end

  # GET /periods/1/edit
  def edit
    @period = Period.find(params[:id])
  end

  # POST /periods
  # POST /periods.json
  def create
    @period = Period.new(params[:period])

    respond_to do |format|
      if @period.save
        format.html { redirect_to @period, notice: 'Period was successfully created.' }
        format.json { render json: @period, status: :created, location: @period }
      else
        format.html { render action: "new" }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /periods/1
  # PUT /periods/1.json
  def update
    @period = Period.find(params[:id])

    respond_to do |format|
      if @period.update_attributes(params[:period])
        format.html { redirect_to @period, notice: 'Period was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.json
  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    respond_to do |format|
      format.html { redirect_to periods_url }
      format.json { head :no_content }
    end
  end
end
