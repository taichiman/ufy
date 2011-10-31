class CreateTwiFollowers < ActiveRecord::Migration
  def change
    create_table :twi_followers do |t|
      t.integer :social_connection_id
      t.integer :id_a
      t.integer :id_b

 #     t.timestamps
    end
  end
end
