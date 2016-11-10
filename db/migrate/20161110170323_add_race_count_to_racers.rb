class AddRaceCountToRacers < ActiveRecord::Migration
  def change
    add_column :racers, :race_count, :integer
  end
end
