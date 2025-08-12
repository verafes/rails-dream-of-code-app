class Course < ApplicationRecord
  belongs_to :coding_class
  belongs_to :trimester
  has_many :enrollments

  delegate :title, to: :coding_class

  def student_name_list
    names_list = []

    enrollments.each do |enrollment|
      student = enrollment.student
      names_list << "#{student.first_name} #{student.last_name}"
    end

    names_list
  end

  def student_email_list
  email_list = []

    enrollments.each do |enrollment|
      student = enrollment.student
      email_list << student.email
    end

    email_list
  end
end
