class RenameColumnXinTableYtoZ < ActiveRecord::Migration
  def change
      rename_column :orders, :quantiy, :quantity
  end
end
