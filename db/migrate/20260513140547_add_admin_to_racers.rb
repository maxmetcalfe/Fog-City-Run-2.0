class AddAdminToRacers < ActiveRecord::Migration[6.1]
  def change
    add_column :racers, :admin, :boolean, default: false
  end
end
