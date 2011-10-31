require "#{Rails.root}/script/vk/vk_avatar.rb"

class VkUser < ActiveRecord::Base

  def self.fill_users_all_inf( uids )

    u = Vk_avatars.new

p '=============sdsdsdsdsdsdsdsds'
p uids


    uids.each do |user_id|

p 'sdsdsdsdsdsdsdsds'
p user_id

      u.update_user_avatar_and_name( user_id )# if VkUser.find_by_vk_id( user_id ).avatar == ""
    end

  end

end

