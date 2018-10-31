require 'rails_helper'

RSpec.describe Links::UrlRedirect do
  describe '.call!' do
    context 'when the link exists' do
      let!(:link) { create(:link) }
      let(:link_short_code) { link.short_code }

      it 'should return the url of the link with the given short_code' do
        url = Links::UrlRedirect.call!(link_short_code)

        expect(url).to eq(link.url)
      end

      it 'should increment the link redirection_count'  do
        redirect_count = link.redirect_count
        Links::UrlRedirect.call!(link_short_code)

        expect(link.reload.redirect_count).to eq(redirect_count + 1)
      end
    end

    context 'when the record does not exist' do
      let(:link_short_code) { 'Unknown' }

      it 'raises RecordNotFound exception' do
        expect {
          Links::UrlRedirect.call!(link_short_code)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
