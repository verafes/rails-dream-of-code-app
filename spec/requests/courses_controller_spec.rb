require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "GET /courses/:id/enrolled_students" do
    let(:coding_class) { 
      CodingClass.create(title: 'Test Class')
    }
    let(:trimester) { 
      Trimester.create(
        year: '2025',
        term: 'Fall',
        start_date: Date.today,
        end_date: Date.today + 3.months,
        application_deadline: Date.today - 1.week
      )
    }
    let(:course) {
      Course.create(coding_class: coding_class,
                    trimester: trimester)
    }

    it "shows the course name and enrolled student" do
      student1 = Student.create!(
        first_name: "AJ",
        last_name: "Adams",
        email: "aj@test.com"
      )

      student2 = Student.create!(
        first_name: "Sam",
        last_name: "Taylor",
        email: "sam@test.com"
      )

      student3 = Student.create!(
        first_name: "Mila",
        last_name: "Johnson",
        email: "mila@test.com"
      )

      [student1, student2, student3].each do |s|
        Enrollment.create!(course: course, student: s)
      end

      get course_enrolled_students_path(course)

      expect(response.body).to include("Test Class")
      expect(response.body).to include("AJ Adams")
      expect(response.body).to include("Sam Taylor")
      expect(response.body).to include("Mila Johnson")
    end
  end
end