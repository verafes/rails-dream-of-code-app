class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student
  has_many :mentor_enrollment_assignments
  has_many :submissions

  def student_name
    student.full_name

  def is_past_application_deadline?
    return false unless course&.trimester&.application_deadline
    created_at > course.trimester.application_deadline
  end
end
