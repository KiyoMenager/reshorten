require 'rails_helper'

RSpec.describe 'Redirections API', type: :request do

  let!(:link) { create(:link) }
  let(:link_short_code) { link.short_code }

  describe 'GET /:short_code' do

    it 'is monitored, calling Links::Redirection' do
      expect(Links::UrlRedirect).to receive(:call!).with(link.short_code).and_return(link.url)
      get "/#{link_short_code}"
    end

    context 'when the link exists' do
      before { get "/#{link_short_code}" }

      it 'redirects to the link url' do
        expect(response).to redirect_to(link.url)
      end

      it 'returns status 302' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when the link does not exist' do
      before { get "/#{link_short_code}" }

      let(:link_short_code) { 'unknown' }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Link/)
      end
    end
  end
end