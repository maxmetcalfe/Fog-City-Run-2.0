class Add < ActiveRecord::Migration
  def change
      add_column :start_items, :finished, :boolean, :default => false
  end
end
