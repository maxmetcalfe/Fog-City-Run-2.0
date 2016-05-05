class RenameColumnXinTableYtoZ < ActiveRecord::Migration
  def change
     rename_column :results, :racer, :racer_id
  end
end
