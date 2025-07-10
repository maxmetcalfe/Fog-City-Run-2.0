class ChangeFieldTypeRaces < ActiveRecord::Migration[4.2]
  def change
    rename_column :races, :in_progress, :state
  end
end
