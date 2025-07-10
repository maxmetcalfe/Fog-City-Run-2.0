class AddRaceInProgress < ActiveRecord::Migration[4.2]
  def change
      add_column :races, :in_progress, :boolean, :default => false
  end
end
