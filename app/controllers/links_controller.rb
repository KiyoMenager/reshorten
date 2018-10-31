class LinksController < ApplicationController
  before_action :set_link, only: [:show, :update, :destroy]

  # POST /api/links
  def create
    @link = Link.create!(link_params)
    json_response(@link, :created)
  end

  # GET /api/links/:short_code
  def show
    json_response(@link)
  end

  # PUT /api/links/:short_code
  def update
    @link.update(link_params)
    head :no_content
  end

  # DELETE /api/links/:short_code
  def destroy
    @link.destroy
    head :no_content
  end


  private

  def link_params
    params.permit(:url)
  end

  def set_link
    @link = Link.find(params[:short_code])
  end
end
