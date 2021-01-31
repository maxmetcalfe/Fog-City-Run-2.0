class ChangeDataTypeNoteData < ActiveRecord::Migration
  def change
    change_column :races, :note, :text
  end
end
