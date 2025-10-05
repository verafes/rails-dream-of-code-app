class Api::V1::CoursesController < ApplicationController

  def index
    courses = Course.all
    render json: {
      courses: courses.map do |course|
        {
          id: course.id,
          title: course.coding_class.title || '',
          application_deadline: course.trimester&.application_deadline,
          start_date: course.trimester&.start_date,
          end_date: course.trimester&.end_date
        }
      end
    }
  end
end