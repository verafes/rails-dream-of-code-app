class Course < ApplicationRecord
  belongs_to :coding_class
  belongs_to :trimester
  has_many :enrollments

  delegate :title, to: :coding_class

  def student_name_list
    enrollments.includes(:student).map { |e| "#{e.student.first_name} #{e.student.last_name}" }
  end

  def student_email_list
    enrollments.includes(:student).map { |e| e.student.email }
  end
end
