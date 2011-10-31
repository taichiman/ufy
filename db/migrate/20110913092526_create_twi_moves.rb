class CreateTwiMoves < ActiveRecord::Migration
  def change
    create_table :twi_moves do |t|
      t.integer :social_connection_id
      t.integer :twi_id
      t.datetime :action_time
      t.boolean :mutal
      t.integer :status

#      t.timestamps
    end
  end
end
