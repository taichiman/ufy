
#*********************************


#  Vk_avatars -
#
#  $Author: taichiman $
#  created at: Fri Sep  6 09:46:12 JST 2011
#  1. Постоянно поддерживает в актуальном состоянии доп инфу об анфоловерах и фоловерах
#  2. Выдает аватарку по id юзера в ВК
#**********************************************************************/



require 'open-uri'
require 'active_record'
require 'yaml'
require 'json'
require File.expand_path( '../../../',  __FILE__)+'/script/vk/vk_http.rb'

class VkUser < ActiveRecord::Base
end

OFFLINE_TOKEN='f8ce9e06fed40952fed4095253fef1c1227fed4fed509504d8c177bb16f3519' #21.09.2011, +- 19:00

  class Vk_avatars

    def initialize
      app_path = File.expand_path( '../../../',  __FILE__)
      dbconfig = YAML::load(File.open(File.join(app_path+'/config/', 'database.yml')))
      ActiveRecord::Base.establish_connection(dbconfig['development'])
      start
    end


    def start
      #loop:обновляем данныe по каждому
      loop do #получим всех текущие токены в контакте
        p 'Ava'
        VkUser.find_each do |user|

          update_user_avatar_and_name( user ) if user.avatar==nil or user.name==nil or ( user.last_update < Time.now-1.hour )

        end
        sleep 5
      end
    end


    #*
    #     api_get_info( uid Vk user )  -> hsh or nil
    #
    #*

    def api_get_info( uid )

      # варианты размера аватарок = 'photo_rec, photo_big, photo_medium_rec'

      url = URI.encode("https://api.vkontakte.ru/method/getProfiles?uid=#{ uid }&fields='photo,photo_medium_rec,'&access_token=#{ OFFLINE_TOKEN }")

      Vk_HTTP.request_api(url)[0]

    end


    #*
    #     update_user_avatar_and_name( uid Vk user )  ->
    #
    #     Update record in VkUser model. Fill name,
    #     avatar_foto
    #
    # используется в двух случаях: 1) на вход подается запись таблицы VkUser, и в ней обновляется инфо о юзере
    # 2) на вход подается uid юзера ВКонтакте, для которого нужно создать запись.
    #
    #
    #*

    def update_user_avatar_and_name( param )

      if !param.class.to_s.include? 'VkUser' # для 2-го случая
        vk_user = VkUser.find_or_create_by_vk_id( param )
        vk_user.vk_id = param
        user_record = vk_user
        uid = param
      else
        user_record = param
        uid = param.vk_id
      end

      begin
        user_info = api_get_info( uid )

        user_record.update_attributes( :avatar => user_info['photo_medium_rec'], :name => user_info['first_name']+' '+user_info['last_name'], :last_update => Time.now )
        p 'Updated :' + user_info.to_s
      rescue  => exc
        p "Error:! MySQL save failed. Message #{ exc.message }"
        Vk_HTTP.write_logs( "vk_avatar_request.log", "MySQL save failed: "+Time.now.to_s )
      end
    end

  end

