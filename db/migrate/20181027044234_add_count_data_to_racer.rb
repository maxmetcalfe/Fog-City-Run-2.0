class AddCountDataToRacer < ActiveRecord::Migration
  def change
    add_column :racers, :count_data, :string, array: true
  end
end
