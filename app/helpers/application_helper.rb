require 'settings'
module ApplicationHelper
  include Settings

  def tabMetrics
    Tab.visible.includes(:metrics)
  end

  def quickLinks
    QuickLink.order("pos ASC, name ASC")
  end
end
