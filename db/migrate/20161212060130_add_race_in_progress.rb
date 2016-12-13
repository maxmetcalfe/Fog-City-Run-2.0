class AddRaceInProgress < ActiveRecord::Migration
  def change
      add_column :races, :in_progress, :boolean, :default => false
  end
end
