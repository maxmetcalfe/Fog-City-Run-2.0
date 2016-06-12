class AddRaceToResults < ActiveRecord::Migration
  def change
    add_column :results, :race_id, :string
    add_index :results, :race_id
  end
end
