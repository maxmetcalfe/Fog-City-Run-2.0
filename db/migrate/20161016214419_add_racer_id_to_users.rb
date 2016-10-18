class AddRacerIdToUsers < ActiveRecord::Migration
  def change
      add_column :users, :racer_id, :integer
  end
end
