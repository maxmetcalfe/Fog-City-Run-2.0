class AddLongestStreakToRacers < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :longest_streak, :integer
  end
end
