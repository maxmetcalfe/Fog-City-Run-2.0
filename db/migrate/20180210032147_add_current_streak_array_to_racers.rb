class AddCurrentStreakArrayToRacers < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :current_streak_array, :text, array:true, default: []
  end
end
