# spec/models/enrollment_spec.rb
require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  # Data setup for all tests in this file
  let(:trimester) do
    Trimester.create!(
      year: '2025',
      term: 'Summer',
      start_date: '2025-07-02',
      end_date: '2025-10-21',
      application_deadline: 1.week.ago
    )
  end

  let(:course) do
    Course.create!(coding_class: coding_class, trimester: trimester)
  end

  let(:student) do
    Student.create!(
      first_name: 'Alice',
      last_name: 'Wilson',
      email: 'alison@example.com'
    )
  end

  let(:coding_class) { CodingClass.create!(title: 'Test Class') }

  describe '#is_past_application_deadline' do

    context 'when enrollment is created before the course application deadline' do
      it 'returns false' do
        enrollment = Enrollment.create!(
          course: course,
          student: student,
          created_at: trimester.application_deadline - 1.day
        )
        expect(enrollment.is_past_application_deadline?).to eq(false)
      end
    end

    context 'when enrollment is created on the course application deadline' do
      it 'returns false' do
        enrollment = Enrollment.create!(
          course: course,
          student: student,
          created_at: trimester.application_deadline
        )
        expect(enrollment.is_past_application_deadline?).to eq(false)
      end
    end

    context 'when enrollment is created after the course application deadline' do
      it 'returns true' do
        enrollment = Enrollment.create!(
          course: course,
          student: student,
          created_at: trimester.application_deadline + 1.day
        )
        expect(enrollment.is_past_application_deadline?).to eq(true)
      end
    end

    context 'when application deadline is missing' do
      before do
        allow(course.trimester).to receive(:application_deadline).and_return(nil)
      end

      it 'returns false' do
        enrollment = Enrollment.create!(
          course: course, 
          student: student, 
          created_at: Time.now
        )
        expect(enrollment.is_past_application_deadline?).to eq(false)
      end
    end

  end
end