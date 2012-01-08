class Metric < ActiveRecord::Base
  validates_presence_of :tab_name, :name, :title, :color
  validates_uniqueness_of :name

  belongs_to :tab, :primary_key => "name", :foreign_key => "tab_name"

  scope :actived, :conditions => ["active = ?", true]
  scope :tab, lambda { |tab_name| {:conditions => {:tab_name => tab_name}, :order => "pos ASC"} }

  def columns
    @metric_class.columns
  end

  def ar_fields
    @metric_class.ar_fields
  end

  def view(bug)
    @metric_class.view(bug)
  end

  def whereClause
    @metric_class.where
  end

  # link with worker
  def metricClass=(metric_class)
    @metric_class = metric_class
  end

end
