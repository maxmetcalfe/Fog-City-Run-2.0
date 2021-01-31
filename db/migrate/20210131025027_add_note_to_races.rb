class AddNoteToRaces < ActiveRecord::Migration
  def change
    add_column :races, :note, :string
  end
end
