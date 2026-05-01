class Add < ActiveRecord::Migration[4.2]
  def change
      add_column :start_items, :finished, :boolean, :default => false
  end
end
