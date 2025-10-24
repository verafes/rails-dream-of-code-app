require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  before do
    @current_trimester = Trimester.create!(
      term: 'Fall',
      year: Date.today.year.to_s,
      start_date: Date.today - 1.day,
      end_date: Date.today + 3.months,
      application_deadline: Date.today - 16.days
    )
    @upcoming_trimester = Trimester.create!(
      term: 'Winter',
      year: Date.today.year.to_s,
      start_date:  @current_trimester.end_date + 1.day,
      end_date: @current_trimester.end_date + 3.months,
      application_deadline:  @current_trimester.end_date
    )
    coding_class1 = CodingClass.create!(title: "Intro to Programming")
    coding_class2 = CodingClass.create!(title: "React")
    coding_class3 = CodingClass.create!(title: "Ruby on Rails")
    @current_course1 = Course.create!(coding_class: coding_class1, trimester: @current_trimester)
    @current_course2 = Course.create!(coding_class: coding_class2, trimester: @current_trimester)

    @current_course3 = Course.create!(coding_class: coding_class2, trimester: @upcoming_trimester)
    @current_course4 = Course.create!(coding_class: coding_class3, trimester: @upcoming_trimester)
    
  end  
  
  describe 'GET /dashboard' do
    it 'returns a 200 OK status' do
      get "/dashboard"

      expect(response).to have_http_status(:ok)
    end

    it 'displays the current trimester' do
      get "/dashboard"
      expect(response.body).to include("Fall - #{Date.today.year}")
    end

    it 'displays links to the courses in the current trimester' do
      get "/dashboard"
      expect(response.body).to include("Intro to Programming")
      expect(response.body).to include("React")
    end

    it 'displays the upcoming trimester' do
      get "/dashboard"
      expect(response.body).to include("Winter - #{Date.today.year}")
    end

    it 'displays links to the courses in the upcoming trimester' do
      get "/dashboard"
      expect(response.body).to include("React")
      expect(response.body).to include("Ruby on Rails")
    end
  end
end