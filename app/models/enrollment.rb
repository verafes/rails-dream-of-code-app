class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student
  has_many :mentor_enrollment_assignments
  has_many :submissions

  def student_name
    student.full_name
  end
end
