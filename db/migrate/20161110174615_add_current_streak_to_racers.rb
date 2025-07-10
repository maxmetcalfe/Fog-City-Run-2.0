class AddCurrentStreakToRacers < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :current_streak, :integer
  end
end
