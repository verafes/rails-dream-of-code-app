class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy]
  before_action :set_dropdowns, only: %i[new edit create update]

  before_action only: [:new, :create, :edit, :update, :destroy] do
    require_role(["admin"])
  end
  
  # GET /courses or /courses.json
  def index
    case session[:role]
    when "admin", "mentor"
      @courses = Course.all
    when "student"
      # Only courses the current student is enrolled in
      @courses = Course.joins(:enrollments).where(enrollments: { student_id: session[:user_id] })
    else
      @courses = []
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
    if session[:role] == "mentor"
      @students = @course.enrollments.includes(:student).map(&:student)
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
    @coding_classes = CodingClass.all
    @trimesters = Trimester.all
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    @coding_classes = CodingClass.all
    @trimesters = Trimester.all
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def enrolled_students
    @course = Course.find(params[:id])
    @enrollments = @course.enrollments.includes(:student).order('students.last_name, students.first_name')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params.expect(:id))
  end
  
  def set_dropdowns
    @coding_classes = CodingClass.all
    @trimesters = Trimester.all
  end

  # Only allow a list of trusted parameters through.
  def course_params
    require(:course).permit(:coding_class_id, :trimester_id, :max_enrollment)
  end
end
