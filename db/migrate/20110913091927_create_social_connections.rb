class CreateSocialConnections < ActiveRecord::Migration
  def change
    create_table :social_connections do |t|
      t.integer :network_id
      t.integer :user_id
      t.integer :social_id
      t.string :token
      t.string :token_secret
      t.integer :followers_count

#      t.timestamps
    end
  end
end
