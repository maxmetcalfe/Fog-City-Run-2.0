class AddEmailToRacers < ActiveRecord::Migration[6.1]
  def change
    add_column :racers, :email, :string
  end
end
