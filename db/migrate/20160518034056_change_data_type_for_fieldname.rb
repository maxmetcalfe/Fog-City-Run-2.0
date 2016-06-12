class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def change
	  change_column :races, :date, :date
  end
end
