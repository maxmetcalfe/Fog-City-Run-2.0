class AddLongestStreakToRacers < ActiveRecord::Migration
  def change
    add_column :racers, :longest_streak, :integer
  end
end
