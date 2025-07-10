class CreateResults < ActiveRecord::Migration[4.2]
  def change
    create_table :results do |t|
      t.integer :rank
      t.integer :bib
      t.references :racer, index: true, foreign_key: true
      t.string :group
      t.string :time
      t.string :date

      t.timestamps null: false
    end
  end
end
