class AddRaceCountToRacers < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :race_count, :integer
  end
end
