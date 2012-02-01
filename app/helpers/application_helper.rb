require 'settings'
module ApplicationHelper
  include Settings

  def releases
    Release.includes(:sprints)
  end

  def sidebarTabs
    Tab.sidebar.includes(:metrics)
  end

  def allTabs
    Tab.visible.includes(:metrics)
  end

  def quickLinks
    QuickLink.order("pos ASC, name ASC")
  end

  def tdval(metric)
    m = Metric.find_by_name(metric + @release._metric) if @release

    c = "-"
    if m
      cl=@worker.get(m.name) unless m.metricClass # link with worker
      m.metricClass=cl
      c = m.calculate_count.to_s if cl

      c = "<a href='/release/"+@release.name+"/"+m.name+"/'>"+c+"</a>"
    end

    raw "<td>"+c+"</td>"
  end

end
