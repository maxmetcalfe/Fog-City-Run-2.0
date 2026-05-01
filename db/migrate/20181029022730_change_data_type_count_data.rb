class ChangeDataTypeCountData < ActiveRecord::Migration[4.2]
  def change
    change_column :racers, :count_data, :text
  end
end
