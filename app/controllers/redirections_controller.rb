class RedirectionsController < ApplicationController

  # GET /:short_code
  def show
    redirect_to Links::UrlRedirect.call!(params[:short_code])
  end
end
