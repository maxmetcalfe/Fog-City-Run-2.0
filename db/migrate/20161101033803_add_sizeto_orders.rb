class AddSizetoOrders < ActiveRecord::Migration
  def change
    add_column :orders, :size, :string
  end
end
