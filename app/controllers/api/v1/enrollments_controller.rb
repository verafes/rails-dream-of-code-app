class Api::V1::EnrollmentsController < ApplicationController
  def index
    # request.format = :json 
    course = Course.find(params[:course_id])
    enrollments = course.enrollments.includes(:student)
    enrollments_data = course.enrollments.map do |enrollment|
      {
        id: enrollment.id,
        studentId: enrollment.student.id,
        studentFirstName: enrollment.student.first_name,
        studentLastName: enrollment.student.last_name,
      }
    end

    render json: { enrollments: enrollments_data }, status: :ok
  end
end