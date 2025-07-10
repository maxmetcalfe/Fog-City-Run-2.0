class ChangeDataTypeNoteData < ActiveRecord::Migration[4.2]
  def change
    change_column :races, :note, :text
  end
end
