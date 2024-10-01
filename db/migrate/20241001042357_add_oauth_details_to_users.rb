class AddOauthDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :provider, :string, default: "google_oauth2"
  end
end
