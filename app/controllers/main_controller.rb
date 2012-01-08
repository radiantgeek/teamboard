require 'settings'
require 'workers'

class MainController < ApplicationController
  include Settings

  respond_to :html, :xml, :json

  # GET /mains
  # GET /mains.json
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # redirect to bugzilla
  def link
    _init()
    @all = _findBugs

    ids = @all.collect { |b| b.id }
    url = bugzillaUrl + "buglist.cgi?quicksearch=" + ids.join("+")

    redirect_to url
  end

  def tab
    _initTab()

    respond_to do |format|
      format.html # tab.html.erb
    end
  end

  def metric
    _init()

    @ajax = "/"+@tab.name+"/"+@metric.name+".json"
    @columns = @metric.columns
    @ar_fields = @metric.ar_fields

    respond_to do |format|
      format.html # metric.html.erb
      format.xml { render xml: loadBugs() }
      format.json { render json: jsonDataTable() }
    end
  end

  private

  def _initTab()
    ActiveRecord::Base.logger = Logger.new(STDERR)

    @tab = Tab.find_by_name(params[:tab])
  end

  def _init
    _initTab()
    @metric = Metric.where(:tab_name => @tab.name, :name => params[:metric]).first

    @worker = Workers.new # should be singleton
    @metric.metricClass=@worker.get(@metric.name) # link with worker
  end

  # all bugs for metric
  def _findBugs
    Bug.includes(:qa_contact, :reporter, :assigned_to).
        joins(:qa_contact, :reporter, :assigned_to).
        where(@metric.whereClause)
  end

  def readDataTableParameters
    @search = '%'+params[:sSearch]+'%' if params[:sSearch]
    @offset = params[:iDisplayStart].to_i if params[:iDisplayStart]
    @per_page = params[:iDisplayLength]

    @sort_column = params[:iSortCol_0].to_i if params[:iSortCol_0]
    @sort_dir = params[:sSortDir_0]=='asc'

    !params[:iDisplayStart].nil?
  end

  def loadBugs()
    dataTable = readDataTableParameters()

    # all bugs for metric
    @all = _findBugs()

    # filtered by keyword
    @filtered = @all
    @filtered = @filtered.where(sql, {:sSearch => @search}) if @search

    # @products - bugs to show
    if dataTable
      order = @ar_fields[@sort_column].to_s + (@sort_dir ? " ASC" : " DESC")
      @products = @filtered.order(order).limit(@per_page).offset(@offset)
    else
      @products = @filtered
    end

    @products = @products.collect { |p|
      @metric.view(p).collect { |e| e == nil ? "" : e.to_s }
    }
  end


  def jsonDataTable()
    loadBugs()

    # return
    {
        "sEcho" => params[:sEcho],
        "iTotalRecords" => @all.count,
        "iTotalDisplayRecords" => @filtered.count,
        "aaData" => @products,
    }
  end

  def sql
    @ar_fields.collect { |z| z.to_s+" LIKE :sSearch" }.join(" OR ")
  end

  private
  include Workers

end
