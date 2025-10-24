require 'rails_helper'

RSpec.describe "Api::V1::Students", type: :request, skip: true do
  describe "POST /api/v1/students" do
    let(:valid_attributes) do
      {
        student: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: 'validstudent@example.com'
        }
      }
    end

    it "creates a new student" do
      expect {
        post '/api/v1/students', params: valid_attributes
      }.to change(Student, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['student']['email']).to eq("validstudent@example.com")
    end
  end

  context "with wrong data types" do
    let(:wrong_types) do
      {
        student: {
          first_name: 123,
          last_name: true,
          email: "test@example.com"
        }
      }
    end

    it "returns validation errors" do
      post '/api/v1/students', params: wrong_types, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "with missing email" do
    let(:invalid_params) do
      {
        student: {
          first_name: "Alice",
          last_name: "Wilson",          
          email: "" 
        }
      }
    end

    it "does not create a student and returns errors" do
      expect {
        post "/api/v1/students", params: invalid_params, as: :json
      }.not_to change(Student, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Email can't be blank")
    end
  end

  context "with duplicate email" do
    before { Student.create!(first_name: "Bob", last_name: "Smith", email: "bob@example.com") }

    let(:duplicate_email) do
      {
        student: {
          first_name: "Bob",
          last_name: "Smith",
          email: "bob@example.com"
        }
      }
    end

    it "does not create a student and returns email uniqueness error" do
      expect {
        post '/api/v1/students', params: duplicate_email, as: :json
      }.not_to change(Student, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Email has already been taken")
    end
  end

  context "with empty payload" do
    it "returns unprocessable_entity" do
      post '/api/v1/students', params: {}, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "with partial payload (missing last_name & email)" do
    let(:partial_payload) do
      { student: { first_name: "Charlie" } } 
    end

    it "returns validation errors" do
      post '/api/v1/students', params: partial_payload, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include(
        "Last name can't be blank", "Email can't be blank"
        )
    end
  end

  context "with invalid email format" do
    let(:invalid_email) do
      {
        student: {
          first_name: "John",
          last_name: "Doe",
          email: "invalid-email"
        }
      }
    end

    it "returns validation error for email format" do
      post '/api/v1/students', params: invalid_email, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Email is invalid")
    end
  end

  context "with extra unexpected parameters" do
    let(:extra_params) do
      {
        student: {
          first_name: "alina",
          last_name: "Stone",
          email: "alina@example.com",
          role: "admin",
          age: 25 
        }
      }
    end

    it "ignores extra params and creates the student" do
      expect {
        post '/api/v1/students', params: extra_params, as: :json
      }.to change(Student, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["student"]["email"]).to eq("alina@example.com")
      expect(json_response["student"]).not_to include("role", "age")
    end
  end

  context "when params are missing the student key" do
    let(:wrong_payload) { { first_name: "John" } }

    it "returns unprocessable_entity with error" do
      post '/api/v1/students', params: wrong_payload, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include(
        "param is missing or the value is empty: student"
        )
    end
  end
end
