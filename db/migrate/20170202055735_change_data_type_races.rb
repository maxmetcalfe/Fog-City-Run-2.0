class ChangeDataTypeRaces < ActiveRecord::Migration
  def change
    change_column :races, :state, :string
  end
end
