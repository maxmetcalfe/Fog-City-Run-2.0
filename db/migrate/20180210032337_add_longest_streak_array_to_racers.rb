class AddLongestStreakArrayToRacers < ActiveRecord::Migration
  def change
    add_column :racers, :longest_streak_array, :text, array:true, default: []
  end
end
