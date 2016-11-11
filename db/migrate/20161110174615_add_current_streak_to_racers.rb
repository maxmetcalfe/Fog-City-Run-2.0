class AddCurrentStreakToRacers < ActiveRecord::Migration
  def change
    add_column :racers, :current_streak, :integer
  end
end
