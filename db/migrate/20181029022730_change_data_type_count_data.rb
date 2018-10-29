class ChangeDataTypeCountData < ActiveRecord::Migration
  def change
    change_column :racers, :count_data, :text
  end
end
