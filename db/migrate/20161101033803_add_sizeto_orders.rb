class AddSizetoOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :size, :string
  end
end
