class AddColumnFavBigToRacer < ActiveRecord::Migration[4.2]
  def change
    add_column :racers, :fav_bib, :int
  end
end
