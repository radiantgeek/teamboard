class CreateMetricDatas < ActiveRecord::Migration
  def self.up
    create_table :metric_datas do |t|
      t.integer :metric_id
      t.float :res
      t.datetime :time

      t.timestamps
    end
    change_table :metric_datas do |t|
      t.index :metric_id
      t.index :time
    end
  end

  def self.down
    drop_table :metric_datas
  end
end
