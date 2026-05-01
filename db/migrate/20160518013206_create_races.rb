class CreateRaces < ActiveRecord::Migration[4.2]
  def change
    create_table :races do |t|
      t.integer :race_id
      t.datetime :date

      t.timestamps null: false
    end
  end
end
