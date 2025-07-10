class AddLongestStreakArrayToRacers < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :longest_streak_array, :text, array:true, default: []
  end
end
