class RenameOrdertoItem < ActiveRecord::Migration[4.2]
  def change
    rename_column :orders, :order, :item
  end
end
