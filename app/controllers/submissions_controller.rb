class SubmissionsController < ApplicationController
  before_action :set_course
  before_action :set_submission, only: [:edit, :update, :show]

  before_action only: [:new, :create] do
    require_role(["student"])
  end

  before_action only: [:edit, :update] do
    require_role(["mentor"])
  end

  # GET /courses/:course_id/submissions
  def index
    @submissions = @course.submissions.includes(:enrollment, :lesson, :mentor)
  end

  def show
    # @submission is already set
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
    @enrollments = @course.enrollments.includes(:student)
    @lessons = @course.lessons
  end

  def create
    @submission = Submission.new(submission_params)
    mentor_assignment = MentorEnrollmentAssignment.find_by(enrollment: @submission.enrollment)
    @submission.mentor = mentor_assignment&.mentor

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
    @enrollments = @course.enrollments.includes(:student)
    @lessons = @course.lessons
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
     @enrollments = @course.enrollments.includes(:student)
    @lessons = @course.lessons

    if @submission.update(submission_params)
      redirect_to course_submission_path(@course, @submission), notice: "Submission was successfully updated."
    else
      render :edit
    end
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
