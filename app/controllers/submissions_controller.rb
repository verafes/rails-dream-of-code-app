class SubmissionsController < ApplicationController
  before_action :set_course
  before_action :set_submission, only: [:edit, :update, :show]

  # GET /courses/:course_id/submissions
  def index
    @submissions = @course.submissions.includes(:enrollment, :lesson)
  end

  def show
    # @submission is already set
  end

  # GET /submissions/new
  def new
    @course = Course.find(params[:course_id])
    @submission = Submission.new
    @enrollments = @course.enrollments.includes(:student)
    @lessons = @course.lessons
  end

  def create
    @course = Course.find(params[:course_id])
    @submission = Submission.new(submission_params)

    if @submission.save
      redirect_to course_path(@course), notice: 'Submission was successfully created.'
    else
      @enrollments = @course.enrollments.includes(:student)
      @lessons = @course.lessons
      render :new
    end
  end

  # GET /submissions/1/edit
  def edit
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
  end

  private

    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_submission
      @submission = @course.submissions.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:lesson_id, :enrollment_id, :mentor_id, :review_result, :reviewed_at)
    end
end
