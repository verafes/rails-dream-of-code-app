class Mentor < ApplicationRecord
  has_many :submissions
  has_many :mentor_enrollment_assignments
  has_many :enrollments, through: :mentor_enrollment_assignments

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
