class CreateVkFollowers < ActiveRecord::Migration
  def change
    create_table :vk_followers do |t|
      t.integer :social_connection_id
      t.integer :id_A
      t.integer :id_B
      t.boolean :sub
 #     t.timestamps
    end
  end
end

