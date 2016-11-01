class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order
      t.integer :user_id
      t.boolean :delivered
      t.integer :quantiy

      t.timestamps null: false
    end
  end
end
