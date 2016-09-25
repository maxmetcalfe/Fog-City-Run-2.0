class AddStravaLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :strava_link, :string
  end
end
