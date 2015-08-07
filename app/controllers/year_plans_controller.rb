class YearPlansController < ApplicationController
  before_action :set_year_plan, only: [:show, :edit, :update, :destroy]

  # GET /year_plans
  # GET /year_plans.json
  def index
    @year_plans = YearPlan.all
  end

  # GET /year_plans/1
  # GET /year_plans/1.json
  def show
    @weeks = @year_plan.weeks.sort_by &:start_date
    @grades = Grade.all
    @subjects = Subject.all
  end

  # GET /year_plans/new
  def new
    @year_plan = YearPlan.new
  end

  # GET /year_plans/1/edit
  def edit
  end

  # POST /year_plans
  # POST /year_plans.json
  def create
    @year_plan = YearPlan.new(year_plan_params)

    respond_to do |format|
      if @year_plan.save
        format.html { redirect_to year_plans_path, notice: 'Year plan was successfully created.' }
        format.json { render :show, status: :created, location: @year_plan }
      else
        format.html { render :new }
        format.json { render json: @year_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /year_plans/1
  # PATCH/PUT /year_plans/1.json
  def update
    respond_to do |format|
      if @year_plan.update(year_plan_params)
        format.html { redirect_to year_plans_path, notice: 'Year plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @year_plan }
      else
        format.html { render :edit }
        format.json { render json: @year_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /year_plans/1
  # DELETE /year_plans/1.json
  def destroy
    @year_plan.destroy
    respond_to do |format|
      format.html { redirect_to year_plans_url, notice: 'Year plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_schedule
    @year_plan = YearPlan.find(params[:id])
    weeks = @year_plan.weeks.sort_by &:start_date
    @grade = Grade.find(params[:grade_id])
    @subject = Subject.find(params[:subject_id])

    @rows = []
    @max_days = 0
    weeks.each_with_index do |week,i|
      row_data = {}
      row_data.store("week_num","#{i+1}")
      row_data.store("date","#{week.start_date.strftime("%d/%m")} - #{week.end_date.strftime("%d/%m")}")
      days = GradeSubject.where(week_id: week.id, grade_id: @grade.id, subject_id: @subject.id)
      if days.count > @max_days
        @max_days = days.count
      end
      hash_days = []
      days.each do |day|
        myday = {}
        myday.store("cw","#{day.classwork}")
        myday.store("hw","#{day.homework}")
        hash_days << myday
      end
      row_data.store("days", hash_days)
      @rows << row_data
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_year_plan
      @year_plan = YearPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def year_plan_params
      params.require(:year_plan).permit(:year_name)
    end
end
