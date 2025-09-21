class Course < ApplicationRecord
  belongs_to :coding_class
  belongs_to :trimester
  has_many :enrollments
   has_many :submissions, through: :enrollments
   has_many :lessons

  delegate :title, to: :coding_class
end
