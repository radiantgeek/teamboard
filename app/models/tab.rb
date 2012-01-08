class Tab < ActiveRecord::Base
  validates_presence_of :name, :title
  validates_uniqueness_of :name

  has_many :metrics, :primary_key => "name", :foreign_key => "tab_name"

  scope :visible, :conditions => ["is_showed = ?", true]

  default_scope :order => "pos ASC"
end
