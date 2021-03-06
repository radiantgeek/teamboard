class Metric < ActiveRecord::Base
  validates_presence_of :tab_name, :name, :title, :color
  validates_uniqueness_of :name

  belongs_to :tab, :primary_key => "name", :foreign_key => "tab_name"

  scope :actived, :conditions => ["active = ?", true]
  scope :tab, lambda { |tab_name| {:conditions => {:tab_name => tab_name}, :order => "pos ASC"} }

  def color=(col)
    if (col.length == 6) # from rails_admin's color picker
      col = "rgb("+col[0, 2].hex.to_s+", "+col[2, 2].hex.to_s+", "+col[4, 2].hex.to_s+")"
    end

    self[:color] = col
  end

  def columns
    @metric_class.columns
  end

  def ar_fields
    @metric_class.ar_fields
  end

  def return_scope
    @metric_class.scope
  end

  def calculate_count
    @metric_class.calc
  end

  def view(bug)
    @metric_class.view(bug)
  end

  # link with worker
  def metricClass=(metric_class)
    @metric_class = metric_class
  end

  def metricClass
    @metric_class
  end

  def to_s
    title
  end
end
