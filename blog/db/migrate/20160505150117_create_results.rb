class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :rank
      t.integer :bib
      t.integer :regeracer
      t.string :group
      t.string :time
      t.string :date

      t.timestamps null: false
    end
  end
end
