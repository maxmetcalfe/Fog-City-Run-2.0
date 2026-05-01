class AddCountDataToRacer < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :count_data, :string, array: true
  end
end
