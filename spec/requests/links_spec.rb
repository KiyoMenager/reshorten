require 'rails_helper'

RSpec.describe 'Links API', type: :request do

  let!(:link) { create(:link) }
  let(:link_short_code) { link.short_code }

  describe 'GET /api/links/:id' do
    before { get "/api/links/#{link_short_code}" }

    context 'when the link exists' do
      it 'returns the link' do
        expect(json_data).not_to be_empty
        expect(json_data['short_code']).to eq(link.short_code)
        expect(json_data['url']).to eq(link.url)
        expect(json_data['redirect_count']).to eq(link.redirect_count)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:link_short_code) { -1 }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Link/)
      end
    end
  end

  describe 'POST /api/links' do
    let(:valid_attributes) { { url: Faker::Internet.url() } }

    context 'when the request is valid' do
      before { post '/api/links', params: valid_attributes }

      it 'returns the created link' do
        expect(json_data['short_code']).not_to be_empty
      end

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is not valid' do
      before { post '/api/links', params: { url: 'invalid' } }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns validation failure message' do
        expect(response.body).to match(/Validation failed: Url is invalid/)
      end
    end
  end

  describe 'PUT /links/:short_code' do
    let(:valid_attributes) { { url: Faker::Internet.url() } }

    context 'when the record exists' do
      before { put "/api/links/#{link_short_code}", params: valid_attributes }

      it 'updates the link' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /links/:short_code' do
    before { delete "/api/links/#{link_short_code}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end