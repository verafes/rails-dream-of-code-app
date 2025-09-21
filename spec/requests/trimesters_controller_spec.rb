require 'rails_helper'

RSpec.describe "Trimesters", type: :request do
  let!(:trimester) do
    Trimester.create!(
      term: "Spring",
      year: "2026",
      start_date: "2026-01-01",
      end_date: "2026-04-01",
      application_deadline: "2025-11-01"
    )
  end
  
  describe "GET /trimesters" do
    context 'trimesters exist' do
      before do
        (1..2).each do |i|
          Trimester.create!(
            term: "Term #{i}",
            year: '2025',
            start_date: '2025-01-01',
            end_date: '2025-01-01',
            application_deadline: '2025-01-01',
          )
        end
      end

      it 'returns a page containing names of all trimesters' do
        get '/trimesters'
        expect(response.body).to include('Term 1 2025')
        expect(response.body).to include('Term 2 2025')
      end
    end
  end

  describe "GET /trimesters/:id" do
    let!(:trimester) do
      Trimester.create!(
        term: "Spring",
        year: "2026",
        start_date: "2026-01-01",
        end_date: "2026-04-01",
        application_deadline: "2025-11-01"
      )
    end

    it "displays the trimester term and year on the show page" do
      get "/trimesters/#{trimester.id}"
      expect(response.body).to include("Spring")
      expect(response.body).to include("2026")
    end
  end

  describe "GET /trimesters/:id/edit" do
    it "shows the edit form with application deadline label" do
      get edit_trimester_path(trimester)
      expect(response.body).to include("Application Deadline")
    end
  end

  describe "PUT /trimesters/:id" do
    it "updates the trimester with valid date" do
      put trimester_path(trimester), params: { trimester: { application_deadline: "2025-12-01" } }
      expect(response).to redirect_to(trimester_path(trimester))
      expect(trimester.reload.application_deadline).to eq(Date.parse("2025-12-01"))
    end

    it "returns 400 when deadline missing" do
      put trimester_path(trimester), params: { trimester: { application_deadline: "" } }
      expect(response).to have_http_status(:bad_request)
    end

    it "returns 400 when invalid date" do
      put trimester_path(trimester), params: { trimester: { application_deadline: "invalid-date" } }
      expect(response).to have_http_status(:bad_request)
    end

    it "returns 404 when trimester not found" do
      put "/trimesters/999", params: { trimester: { application_deadline: "2025-12-01" } }
      expect(response).to have_http_status(:not_found)
    end
  end
end