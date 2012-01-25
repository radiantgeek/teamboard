require 'converter'
require 'workers'

class SyncController < ApplicationController
  respond_to :html, :json

  # GET /sync
  # GET /sync.json
  def sync
    require 'bugzilla'

    s = syncUsers + "<br/>" + syncBugs + "<br/>" +calculation

    render :html, :json => s
  end

  # GET /calc
  # GET /calc.json
  def calc
    render :html, :json => calculation
  end

  private
  include Workers

  def calculation
    good = 0
    @worker = Workers.new

    Metric.actived.all.each { |m|
      m.metricClass=@worker.get(m.name)

      calc = m.calculate_count

      data = MetricData.new({:metric_id => m.id, :time => DateTime.now, :res => calc})
      data.save
      good += 1;
    }
    (good.to_s + " metric(s) calculated")
  end

  # work like "user matching" in Bugzilla
  #
  # see http://www.bugzilla.org/docs/tip/en/html/api/Bugzilla/WebService/User.html#get
  def syncUsers
    # can't just get full list of users :(
    @users = Bugzilla::Bugzilla.instance.users({"match"=>["i"], "include_disabled"=>"true"})
    #@users = Bugzilla::Bugzilla.instance.users({"match"=>["mfisoft"], "include_disabled"=>"true"})
    syncForClass(@users, User) { |u| u }
  end

  def syncBugs
    a = Sync.last
    if a == nil
      #last_time = (DateTime.now-1).to_s
      bugs = Converter.search({"creation_time"=>"2001-01-01T00:00:00"})
    else
      last_time = a.sync.to_s + "T00:00:00"
      bugs = Converter.search({"last_change_time"=>[last_time]})
    end

    res = syncForClass(bugs, Bug) { |b|
      b.reporter = User.find_by_name(b.reporter)
      b.qa_contact = User.find_by_name(b.qa_contact)
      b.assigned_to = User.find_by_name(b.assigned_to)
      b
    }

    l = Sync.new("sync" => DateTime.now)
    l.save

    res
  end

  def syncForClass(arr, clazz)
    good = 0
    bad = Array.new
    arr = arr.values if arr.is_a? Hash
    arr.each do |item|
      item = yield item
      if item != nil
        id = item.id
        if clazz.exists?(id)
          u = clazz.find id
        else
          u = clazz.new item
          u.id = id
          u.testsfailed = 0 if u.is_a? Bug
          u.comment = "" if u.is_a? Bug
        end
        if u.update_attributes item
          good += 1
        else
          bad.push id
        end
        u.save
      end
    end

    res = " Last " + good.to_s + " modified "+clazz.to_s.chomp+"(s) synchonized"
    res += " WARNING! Problems with ["+bad.join(", ")+"] " if bad.size>0
    res
  end


end
