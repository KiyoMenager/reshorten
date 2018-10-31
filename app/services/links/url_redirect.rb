class Links::UrlRedirect
  # A service object responsible for retrieving the URL associated with the
  # given :short_code.
  #
  # Calling this service increments the Link's :redirect_count using
  # ActiveRecord.CounterCache.increment_counter avoiding stale record update
  # on race conditions.
  #
  # If performance becomes an issue, consider switching the persistence layer
  # to an in-memory store like redis.
  #
  def self.call!(short_code)
    new(short_code).call
  end

  def call
    url = Link.find(short_code).url
    Link.increment_counter(:redirect_count, short_code)
    url
  end

  private

  attr_reader :short_code

  def initialize(short_code)
    @short_code = short_code
  end
end