require 'rails_helper'

RSpec.describe "Mentors", type: :request do
  let!(:mentor1) do
    Mentor.create!(
      first_name: "Alice",
      last_name: "Wilson",
      email: "alice@example.com",
      max_concurrent_students: 3
    )
  end

  let!(:mentor2) do
    Mentor.create!(
      first_name: "John",
      last_name: "Smith",
      email: "john@example.com",
      max_concurrent_students: 5
    )
  end

  describe "GET /mentors" do
    it "loads the index page with all mentors" do
      get '/mentors'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Alice")
      expect(response.body).to include("John")
    end
  end

  describe "GET /mentors/:id" do
    it "loads the show page for mentor1" do
      get "/mentors/#{mentor1.id}"
      expect(response).to have_http_status(:ok) 
      expect(response.body).to include("Alice")
      expect(response.body).to include("Wilson")
      expect(response.body).to include("alice@example.com")
    end

    it "loads the show page for mentor2" do
      get "/mentors/#{mentor2.id}"
      expect(response).to have_http_status(:ok) 
      expect(response.body).to include("John")
      expect(response.body).to include("Smith")
      expect(response.body).to include("john@example.com")
    end
  end
end