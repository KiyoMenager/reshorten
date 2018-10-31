class RedirectionsController < ApplicationController
  before_action :set_url, only: [:show]

  # GET /:short_code
  def show
    redirect_to @url
  end

  private

  def set_url
    @url = Link.find(params[:short_code]).url
  end
end
