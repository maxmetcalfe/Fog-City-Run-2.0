class RenameOrdertoItem < ActiveRecord::Migration
  def change
    rename_column :orders, :order, :item
  end
end
