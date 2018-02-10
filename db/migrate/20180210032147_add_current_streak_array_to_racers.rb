class AddCurrentStreakArrayToRacers < ActiveRecord::Migration
  def change
    add_column :racers, :current_streak_array, :text, array:true, default: []
  end
end
