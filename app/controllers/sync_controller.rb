class SyncController < ApplicationController
  respond_to :html, :json

  # GET /sync
  # GET /sync.json
  def sync
    respond_to do |format|
      format.html # sync.html.erb
    end
  end

  # GET /calc
  # GET /calc.json
  def calc
    respond_to do |format|
      format.html # calc.html.erb
    end
  end

end
