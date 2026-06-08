class MoveTabCountToRacers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :tab_count, :integer
    add_column :racers, :tab_count, :integer, default: 0, null: false
  end
end
