class SprintController < ApplicationController
  respond_to :html, :xml, :json

  # GET /sprint
  # GET /sprint.json
  def sprint
    respond_to do |format|
      format.html # sprint.html.erb
    end
  end

  # GET /release
  # GET /release.json
  def release
    respond_to do |format|
      format.html # release.html.erb
    end
  end

end
