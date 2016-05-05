class ChangeColumnName < ActiveRecord::Migration
    def change
        rename_column :result, :regeracer, :racer
    end
end
