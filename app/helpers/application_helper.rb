require 'settings'
module ApplicationHelper
  include Settings

  def releases
    Release.includes(:sprints)
  end

  def visibleTabs
    Tab.visible.includes(:metrics)
  end

  def allTabs
    Tab.includes(:metrics)
  end

  def quickLinks
    QuickLink.order("pos ASC, name ASC")
  end

  def tdval(metric)

    m = Metric.find_by_name(metric + @release._metric)

    if m.nil?
      c = "-"
    else
      m.metricClass=@worker.get(m.name) unless m.metricClass # link with worker
      c = m.calculate_count.to_s
    end

    raw "<td>"+c+"</td>"
  end
end
