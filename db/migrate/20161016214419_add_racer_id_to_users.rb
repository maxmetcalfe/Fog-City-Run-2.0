class AddRacerIdToUsers < ActiveRecord::Migration[4.2]
  def change
      add_column :users, :racer_id, :integer
  end
end
