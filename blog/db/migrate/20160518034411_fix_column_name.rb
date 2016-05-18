class FixColumnName < ActiveRecord::Migration
  def change
	  rename_column :results, :date, :race_id
  end
end
