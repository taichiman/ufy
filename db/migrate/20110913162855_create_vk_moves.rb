class CreateVkMoves < ActiveRecord::Migration
  def change
    create_table :vk_moves do |t|
      t.integer :social_connection_id
      t.integer :vk_id
      t.boolean :sub
      t.integer :status
      t.datetime :action_time

#      t.timestamps
    end
  end
end

