class CreateStartItems < ActiveRecord::Migration[4.2]
  def change
    create_table :start_items do |t|
      t.integer :racer_id
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :bib
      t.integer :race_id

      t.timestamps null: false
    end
  end
end
