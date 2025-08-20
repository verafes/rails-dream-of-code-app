require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "POST /students" do
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
      expect(response.body).to include('KJ')
      expect(response.body).to include('AJ')
    end
    
    it 'loads the show page correctly for a student' do
      get "/students/#{student.id}"
      expect(response.body).to include('KJ')
      expect(response.body).to include('Loving')
      expect(response.body).to include('kj@test.com')
    end
  end
end