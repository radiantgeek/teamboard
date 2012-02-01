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

  def tab
    _init

    @tab.metrics.each { |m| m.metricClass=@worker.get(m.name) } # link with worker

    respond_to do |format|
      format.html # tab.html.erb
    end
  end

  def metric
    _init

    @ajax = "/"+@tab.name+"/"+@metric.name+".json"
    @columns = @metric.columns
    @ar_fields = @metric.ar_fields

    respond_to do |format|
      format.html # metric.html.erb
      format.xml { render xml: loadBugs() }
      format.json { render json: jsonDataTable() }
    end
  end

  # redirect to bugzilla
  def link
    _init
    @all = _findBugs

    ids = @all.collect { |b| b.id }
    url = bugzillaUrl + "buglist.cgi?quicksearch=" + ids.join("+")

    redirect_to url
  end

  # historical data for diagrams
  def data
    _init

    respond_to do |format|
      format.xml { render xml: _data }
      format.json { render json: _data }
    end
  end

  private

  def _data
    res = Array.new
    all = MetricData.by_metric(@metric.id)

    if @release
      start = @release.start-40 # 40 days
      stop = @release.stop+7*8 # 8 weeks?
      all = all.where(:time => [start..stop]) if @release
    end

    min = all.last.time.to_datetime.to_i
    max = all.first.time.to_datetime.to_i
    dt = (max-min)/400 # return only 400 points
    prev = max+2*dt
    all.each { |a|
      t = a.time.to_datetime.to_i
      if (prev-t)>dt
        res.push([t*1000, a.res])
        prev = t
      end
    }

    path = "/"+@metric.tab_name+"/"
    path = "/release/"+@release.name+"/" if @release

    {"key" => path+@metric.name, "name" => @metric.title,  "type" => "spline", "color" => _color(@metric.color), "data" => res}
  end

  def _color(c)
    c.gsub!("rgb(", "").gsub!(")", "")
    a=c.split(",")
    a.collect! { |o| "%02x" % o.to_i }
    "#"+a.join("")
  end

  def _init
    ActiveRecord::Base.logger = Logger.new(STDERR)
    @worker = Workers.new # should be singleton

    @tab = Tab.find_by_name(params[:tab]) if params[:tab]

    @release = Release.find_by_name(params[:release]) if params[:release]

    @metric = Metric.where(:name => params[:metric]).first if params[:metric]
    @metric.metricClass=@worker.get(@metric.name) if @metric # link with worker

    @tab = Tab.find_by_name(@metric.tab_name) unless @tab
  end

  # all bugs for metric
  def _findBugs
    @metric.return_scope
  end

  def readDataTableParameters
    @search = '%'+params[:sSearch]+'%' if params[:sSearch] && !params[:sSearch].empty?
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
