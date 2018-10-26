require 'rails_helper'

RSpec.describe Link, type: :model do
  let!(:link) { create(:link) }

  describe '.url' do
    it { should allow_value(Faker::Internet.url()).for(:url) }

    it { should_not allow_value("").for(:url) }
    it { should_not allow_value(nil).for(:url) }
    it { should_not allow_value("not_an_url").for(:url) }
  end

  describe '.short_code generation' do
    it 'should be url safe' do
      expect(link.short_code).to match(/\A[0-9a-zA-Z_]+\z/)
    end

    it 'should have length of 6' do
      expect(link.short_code.length).to eq(6)
    end
  end

  describe '.redirect_count' do
    it 'defaults to 0' do
      expect(link.redirect_count).to eq(0)
    end
  end

end
