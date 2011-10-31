class CreateVkUsers < ActiveRecord::Migration
  def change
    create_table :vk_users do |t|
      t.integer :vk_id
      t.string :avatar
      t.string    :name
      t.datetime :last_update
    end
  end
end

