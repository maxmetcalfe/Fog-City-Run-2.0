class RemoveFieldNameFromTableName < ActiveRecord::Migration
  def change
    remove_column :races, :race_id, :integer
  end
end
