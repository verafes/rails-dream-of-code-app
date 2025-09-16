# spec/models/enrollment_spec.rb
require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:trimester) do
    Trimester.create!(
      year: '2025',
      term: 'Summer',
      start_date: '2025-07-02',
      end_date: '2025-10-21',
      application_deadline: 1.week.ago
    )
  end

  let(:coding_class) { CodingClass.create!(title: 'Test Class') }

  let(:course) { Course.create!(coding_class: coding_class, trimester: trimester) }

  let(:student) do
    Student.create!(
      first_name: 'Alice',
      last_name: 'Wilson',
      email: 'alison@example.com'
    )
  end

  def create_enrollment_at(time)
    Enrollment.create!(course: course, student: student, created_at: time)
  end

  describe '#is_past_application_deadline' do
    context 'when enrollment is created before the course application deadline' do
      it 'returns false' do
        enrollment = create_enrollment_at(trimester.application_deadline - 1.day)
        expect(enrollment.is_past_application_deadline?).to eq(false)
      end
    end

    context 'when enrollment is created on the course application deadline' do
      it 'returns false' do
        enrollment = create_enrollment_at(
          trimester.application_deadline
        )
        expect(enrollment.is_past_application_deadline?).to eq(false)
      end
    end

    context 'when enrollment is created after the course application deadline' do
      it 'returns true' do
        enrollment = create_enrollment_at(
          trimester.application_deadline + 1.day
        )
        expect(enrollment.is_past_application_deadline?).to eq(true)
      end
    end

    context 'when application deadline is missing' do
      before do
        allow(course.trimester).to receive(:application_deadline).and_return(nil)
      end

      it 'returns false' do
        enrollment = create_enrollment_at(Time.current)
        expect(enrollment.is_past_application_deadline?).to eq(false)
      end
    end

  end
end