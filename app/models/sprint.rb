class Sprint < ActiveRecord::Base
    belongs_to :release

  def to_s
    title
  end
end
