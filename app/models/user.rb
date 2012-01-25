class User < ActiveRecord::Base
  belongs_to :team

  def to_s
    real_name
  end
end
