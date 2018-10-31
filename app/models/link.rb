class Link < ApplicationRecord
  before_create :set_short_code, :set_redirect_count

  validates_format_of :url, with: URI.regexp
  validates_format_of :short_code, with: /\A[0-9a-zA-Z_]{6}\z/, on: :save

  private

  def set_short_code
    self.short_code = SecureRandom.urlsafe_base64(6)[0..5]
  end

  def set_redirect_count
    self.redirect_count = 0
  end
end
