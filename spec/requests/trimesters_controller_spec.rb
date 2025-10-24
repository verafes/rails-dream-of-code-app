require 'rails_helper'

RSpec.describe "Trimesters", type: :request do
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
        expect(response).to have_http_status(:ok) 
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
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Spring")
      expect(response.body).to include("2026")
    end

    context 'when there are no trimesters' do
      it 'shows empty state message' do
        get '/trimesters'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Trimesters")
        expect(response.body).not_to match(/<li>/)
      end
    end
  end
end