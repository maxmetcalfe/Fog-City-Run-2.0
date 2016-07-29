class RenameColumnXinTableYtoZ < ActiveRecord::Migration
  def change
      rename_column :results, :group, :group_name
  end
end
