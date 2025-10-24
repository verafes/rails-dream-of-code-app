class Api::V1::CoursesController < ApplicationController

  def index
    current_trimester = Trimester.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)
    if current_trimester
      courses_arr = current_trimester.courses
      courses_hash = {
        courses: courses_arr.map do |course|
          {
            id: course.id,
            title: course.coding_class.title || '',
            application_deadline: course.trimester&.application_deadline,
            start_date: course.trimester&.start_date,
            end_date: course.trimester&.end_date
          }
        end
      }
    render json: courses_hash, status: :ok
    end
  end
end