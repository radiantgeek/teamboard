class Sprint < ActiveRecord::Base
  validates_presence_of :name, :title, :release_name
  validates_uniqueness_of :name

  belongs_to :release, :primary_key => "name", :foreign_key => "release_name"

  scope :actived, :conditions => ["active = ?", true]

  scope :before,
        lambda { |release_name, start| {
            :conditions => ["release_name=:r AND start < :s", {:r=>release_name, :s=>start}],
            :order => "start DESC"
        } }


  def previous
    Sprint.before(release_name, start).first
  end

  def to_s
    title
  end
end
