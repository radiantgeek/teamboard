class MetricData < ActiveRecord::Base
  self.table_name = :metric_datas
  belongs_to :metric

  scope :by_metric, lambda { |metric_id| {:conditions => {:metric_id => metric_id}, :order => "time DESC"} }
end
