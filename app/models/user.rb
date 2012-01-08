class User < ActiveRecord::Base

  def to_s
    real_name
  end
end
