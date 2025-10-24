require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "GET /students" do
    let!(:student) { 
        Student.create(
          first_name: "KJ",
          last_name: "Loving",
          email: "kj@test.com"
        )
      }
    let!(:student2) { 
      Student.create(
        first_name: "AJ",
        last_name: "Suning",
        email: "aj@test.com"
      )
    }

    it 'loads the index page correctly' do
      get '/students'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('KJ')
      expect(response.body).to include('AJ')
    end
    
    it 'loads the show page correctly for a student' do
      get "/students/#{student.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('KJ')
      expect(response.body).to include('Loving')
      expect(response.body).to include('kj@test.com')
    end
  end

  describe "GET /students/sorted_students" do
    let!(:student1) { Student.create!(first_name: "KJ", last_name: "Loving", email: "kj@test.com") }
    let!(:student2) { Student.create!(first_name: "AJ", last_name: "Suning", email: "aj@test.com") }
    let!(:student3) { Student.create!(first_name: "Mila", last_name: "Johnson", email: "mila@test.com") }

    it "returns students sorted alphabetically by last name then first name" do
      get '/students/sorted_students'
      expect(response).to have_http_status(:ok)

      expect(response.body.index('Johnson')).to be < response.body.index('Loving')
      expect(response.body.index('Loving')).to be < response.body.index('Suning')
      expect(response.body.index('Mila')).to be < response.body.index('KJ')
      expect(response.body.index('KJ')).to be < response.body.index('AJ')
    end
  end
end