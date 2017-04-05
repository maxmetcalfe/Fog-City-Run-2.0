class AddColumnFavBigToRacer < ActiveRecord::Migration
  def change
    add_column :racers, :fav_bib, :int
  end
end
