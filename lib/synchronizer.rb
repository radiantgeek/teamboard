#coding: utf-8

require 'bugzilla'
require 'sync'


module Synchronizer
  def sync
    syncUsers()
    
    render :json => syncBugs()
    #        render :json => "test"
  end
  
  # ----------------------------------------------
  # synchronize
  
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
  
  def syncUsers
    @users = Bugzilla::Bugzilla.instance.users({"match"=>["@"]})
    syncForClass(@users, User) { |u| u }
  end
  
  def syncBugs
    a = Sync.last
    if a == nil
      last_time = (DateTime.now-10*360).to_s
    else
      last_time = a.sync.to_s + "T00:00:00"
    end    
    bugs = JanBug.search({"last_change_time"=>[last_time]})
    
    res = syncForClass(bugs, Bug) { |b|
      b.reporter = User.find(b.reporter)
      if b.qa_contact
        b.qa_contact = User.find(b.qa_contact)
      else
        b.qa_contact = User.find(50)
      end
      b.assigned_to = User.first(:conditions => { :name => b.assigned_to})
      b
    }
    
    l = Sync.new("sync" => DateTime.now)
    l.save
    
    res
  end
end