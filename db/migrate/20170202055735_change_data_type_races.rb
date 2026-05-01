class ChangeDataTypeRaces < ActiveRecord::Migration[4.2]
  def change
    change_column :races, :state, :string
  end
end
