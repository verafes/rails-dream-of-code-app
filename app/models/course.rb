class Course < ApplicationRecord
  belongs_to :coding_class
  belongs_to :trimester
  has_many :enrollments
  has_many :submissions, through: :enrollments
  has_many :lessons
  has_many :mentors, through: :mentor_enrollment_assignments

  delegate :title, to: :coding_class
end
