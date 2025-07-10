class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.string :order
      t.integer :user_id
      t.boolean :delivered
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
