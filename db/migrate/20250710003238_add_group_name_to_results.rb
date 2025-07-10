class AddGroupNameToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :group_name, :string
  end
end
