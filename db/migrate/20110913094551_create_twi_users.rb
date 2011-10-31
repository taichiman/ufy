class CreateTwiUsers < ActiveRecord::Migration
  def change
    create_table :twi_users do |t|
      t.integer :twi_id
      t.string :avatar
      t.datetime :last_update

#      t.timestamps
    end
  end
end
