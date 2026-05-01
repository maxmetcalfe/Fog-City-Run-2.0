class AddRaceIdToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :race_id, :integer
  end
end
