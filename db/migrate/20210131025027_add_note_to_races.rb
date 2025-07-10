class AddNoteToRaces < ActiveRecord::Migration[4.2]
  def change
    add_column :races, :note, :string
  end
end
