require 'workers'

class Release < ActiveRecord::Base
  validates_presence_of :name, :title
  validates_uniqueness_of :name

  has_many :sprints, :primary_key => "name", :foreign_key => "release_name", :order => "start DESC"

  default_scope :order => "start DESC"

  scope :actived, :conditions => ["active = ?", true]

  # add for metric
  def _metric
    version.gsub(/\./, "")
  end

  def dreType(type)
    i = DRE.new("", start, stop, type).calc
    return "--" if i.nan?
    "%.3f" % i
  end

  def to_s
    title
  end

  private
  include Workers
end
