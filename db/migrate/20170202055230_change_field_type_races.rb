class ChangeDataTypeRaces < ActiveRecord::Migration
  def change
    rename_column :races, :in_progress, :state
  end
end
