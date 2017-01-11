class AddGroupToStartList < ActiveRecord::Migration
  def change
    add_column :start_items, :group, :string
  end
end
