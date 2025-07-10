class AddGroupToStartList < ActiveRecord::Migration[4.2]
  def change
    add_column :start_items, :group, :string
  end
end
