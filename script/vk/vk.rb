# coding: utf-8
#/**********************************************************************

#  vk.rb -
#
#  $Author: taichiman $
#  created at: Fri Sep  6 09:46:12 JST 2011
#  Регистрирует анфоловеров ВКонтакте
#**********************************************************************/

require 'open-uri'
require 'active_record'
require 'yaml'
require 'json'
require './vk_http.rb'
require './vk_avatar.rb'

class Network < ActiveRecord::Base
end

#class User < ActiveRecord::Base
#end

class SocialConnection < ActiveRecord::Base
end

class VkFollower < ActiveRecord::Base
end

class VkMove < ActiveRecord::Base
end

class VkUser < ActiveRecord::Base
end


class Vk_folowers

  def self.init
    app_path = File.expand_path( '../../../',  __FILE__ )
    dbconfig = YAML::load( File.open(File.join(app_path + '/config/', 'database.yml' )))
    ActiveRecord::Base.establish_connection( dbconfig['development'] )
  end


  def start
    p Time.now

    #инициализируем начало в файле лога ошибок-->
    f=File.open("./vk_request_errors.log",'a') do |f|
      f.puts "**************************\n"
      f.puts Time.now
      f.puts "**************************\n"
    end
    #инициализируем файл лога ошибок--<

    network_id = Network.find_or_create_by_name('vkontakte').id

    #loop:обновляем данныe по каждому юзеру
    loop do #получим всех текущие токены в контакте

p 'Follower'

      SocialConnection.where( "network_id=#{ network_id }" ).find_each do |user|
      check_friends( user )
      defined?(i) ? i+=1 : i=1
      puts "checking users: #{i} for #{user.user_id}";

      end
    end

  end


    #*
    #     api_get_friends( SocialConnection )  -> ary or nil
    #
    #*

    def api_get_friends(sc)

      url = URI.encode("https://api.vkontakte.ru/method/friends.get?uid=#{ sc.social_id }&access_token=#{ sc.token }")

      puts url
      puts 'Get friends <+><+><+><+><+><+>'

      Vk_HTTP.request_api(url)

    end


    ##*
    ##     api_get_subscribers( code )  -> hash{ count, users } or nil
    ##
    ##*

    #def api_get_subscribers( code )

    #  url = URI.encode("https://api.vkontakte.ru/method/execute?code=#{code}&access_token=d6aa0cd3d6b6b09cd6b6b09c68d692dc845d6b6d6b5980242c3ab94248d6a21")

    #  puts url
    #  puts 'Get subscribers <>.<>.<>.<>.<>.<>'

    #p  request_api( url )

    #exit

    #end


    ##*
    ##     api_get_subscribers_count( SocialConnection, offset, count )  -> hash{ count, users } or nil
    ##
    ##*

    #def api_get_subscribers_count( sc, offset, count )

    #  url = URI.encode("https://api.vkontakte.ru/method/subscriptions.getFollowers?uid=#{ sc.social_id }&offset=#{ offset }&count=#{ count }&access_token=#{ sc.token }")

    #  puts url

    #  count = request_api( url )

    #  puts "Get subscribers count <>.<> : #{count}"

    #  count
    #end


    #*
    #     api_get_subscribers( SocialConnection, offset, count )  -> hash{ count, users } or nil
    #
    #*

    def api_get_subscribers( sc, offset, count )

      url = URI.encode("https://api.vkontakte.ru/method/subscriptions.getFollowers?uid=#{ sc.social_id }&offset=#{ offset }&count=#{ count }&access_token=#{ sc.token }")

      puts url
      puts 'Get subscribers <>.<>.<>.<>.<>.<>'

      Vk_HTTP.request_api( url )

    end

    ##*
    ##    get_subscribers( SocialConnection )  -> ary users or nil
    ##
    ##*

    #def get_subscribers(sc)
    #  #получим кол-во подписчиков
    #  s = api_get_subscribers_count( sc, 0, 1 )

    #return nil if s == nil #в ответе API была ошибка

    #  s_count=s[ 'count' ]

    #return(Array.new) if s_count==0 #число подписчиков = 0

    #  puts '-->> subsrciber count: ' + s_count.to_s

    #  #loop: получим подписчиков из Vk API
    #  subscribers=[]
    #  request=String.new

    ## request="return API.subscriptions.getFollowers({\"uid\":#{ sc.social_id },\"offset\":#{ 0 },\"count\":#{ 1000 }});"

    ## request="return API.subscriptions.getFollowers({\"uid\":#{ sc.social_id }});"
    # request="return API.subscriptions.getFollowers({\"uid\":102405972});"

    ## request="return API.subscriptions.get({\"uid\":#{ sc.social_id }});"

    ## request="return API.status.get({\"uid\":#{ sc.social_id }});"

    ## request="return API.getUserSettings();"


    ## request="return API.friends.get({\"uid\":#{ sc.social_id }});"

    ## request="return API.subscriptions.getFollowers({'uid':#{ sc.social_id },'offset':#{ 0 },'count':#{ 1000 } };)"

    ## request+="return API.getProfiles( { 'uids' : 1, 'access_token' : '#{ sc.token }' });"
    ## request+="API.getProfiles( { 'uids' : 1 } )"

    ##request+="return API.getProfiles({\"uids\":API.audio.search({\"q\":\"Beatles\",\"count\":3})@.owner_id})@.last_name;"
    ##k=1
    ##request+="return API.getProfiles({\"uids\":"+"\"#{k}\""+")@.last_name;"
    ##request+="return API.getProfiles({\"uids\":#{k}})@.last_name;"
    #p "****"
    #p api_get_subscribers(request)

    #exit

    ##  0.step( s_count, 1000 ) do |i|

    ##    request+="API.subscriptions.getFollowers?uid=#{ sc.social_id }&offset=#{ offset }&count=#{ count }&access_token=#{ sc.token };"

    ##  end

    #  subscribers
    #end



    #*
    #    get_subscribers( SocialConnection )  -> ary users or nil
    #
    #*

    def get_subscribers( sc )
      #получим кол-во подписчиков
      s = api_get_subscribers( sc, 0, 1 )
    return nil if s == nil #в ответе API была ошибка

      s_count=s[ 'count' ]

    return(Array.new) if s_count==0 #число подписчиков = 0

      puts '-->> subsrciber count: ' + s_count.to_s

      #loop: получим подписчиков из Vk API
      subscribers=[]

      0.step( s_count, 1000 ) do |i|

        i_errors = 0  # счетчик попыток получить кол-во подписчиков по API
        get_temp = nil
        while get_temp == nil do #ошибка в ответе на запрос, повторим опять

          get_temp = api_get_subscribers( sc, i, 1000 )

          i_errors += 1 if get_temp == nil  # обработка ошибок посреди получения списка подписчиков
          if i_errors == 3 then
            puts 'Dear admin, error in get subscribers on HTTP'; print "\a"
     return nil # если 10 ошибок получения ответа подряд
          end

        end
        subscribers.push(get_temp[ 'users' ]).flatten!
      end

      subscribers
    end


    #*
    #    diff_friends ( f1 - ary db_friends, f2 - ary get_api_friends )  -> ary [ ary unfollowers, ary new_followers ]
    #
    #*

    def diff_friends( f1, f2 )
      #удаляем общие элементы из массивов, и возвращаем с оставшимися. в 1-м остаются анфоловеры, вовтором - новые фоловеры
      puts 'Need update followers'
      print "\a"

    p f1
    p f2
      f_temp=Array.new(f1)

      f1=f1-f2
      f2=f2-f_temp

    p 'diff:'
    p f1
    p f2
      f=Array.new
      f.push(f1,f2)
    #p '00>'
    #p f

    end


    ##CREATE------------

    #*
    #     create_followers( SocialConnection, ary follovers, boolean sub (subscribe?) )
    #
    #*

    def create_followers( sc, followers, sub)
      return if followers==nil
      return if followers==[]
      #Option 3:cofeeepowered
      inserts = []

      followers.count.times do |i|
        inserts.push "(#{ followers[i] },#{ sc.id },#{ sub } )"
      end
      VkFollower.connection.execute "INSERT INTO vk_followers ( id_A, social_connection_id, sub ) VALUES #{ inserts.join(", ") }"

    end


    #*
    #     create_vk_moves( SocialConnection, ary follovers, boolean sub (subscribe?), int status )
    #
    #*

    def create_vk_moves( sc , followers, sub, status)

      followers.each do |f|
        VkMove.create( :social_connection_id => sc.id, :vk_id =>f, :sub => sub, :status => status, :action_time => Time.now )

        VkUser.find_or_create_by_vk_id( :vk_id => f, :last_update => Time.now )

      end

    end


    #*
    #     update_followers( SocialConnection, ary [ ary unfollowers, ary new_followers ], boolean sub (subscribe?) )
    #
    #*

    def update_followers(sc,followers_diff,sub)

      #добавим новых фоловеров
      if followers_diff[1]!=[]
        create_followers( sc, followers_diff[1], sub)
        create_vk_moves( sc, followers_diff[1] , sub , 0 )
      end

      #удалим анфоловеров
      #TODO Оптимизировать удаление
      if followers_diff[0]!=[]
        @unfollowed=VkFollower.where(:social_connection_id=>sc.id,:id_A=>followers_diff[0],:sub=>sub).all
        @unfollowed.each { |u| u.destroy}
        create_vk_moves( sc, followers_diff[0] , sub , 1 )
      end

    end



    #
    # check_friends( social connection[i] ) ->
    #
    #
    #
    def check_friends( sc )
    #InitialCreate--------------> если друзей или подписчиков у этого токена нет, то получить их


      #получим друзей, falseу
      if VkFollower.find_by_social_connection_id_and_sub( sc.id, false) == nil then
        p 'Initial friends'
        friends = api_get_friends( sc )
        create_followers( sc, friends, false )
      end



      #получим подписчиков, true
      if VkFollower.find_by_social_connection_id_and_sub( sc.id, true ) == nil then
        p 'Initial subscribers'
    p Time.now
        subscribers = get_subscribers( sc )
    p Time.now
        create_followers( sc, subscribers, true )
    p Time.now
      end
    #InitialCreate--------------<


    #CheckFriends-------------->

      #TODO оптимизировать проверку
      # фоловеры теперь есть в базе, проверим текущее состояние сайта ВК
      # сверим друзей

      get_friends = api_get_friends( sc )

    p 'Frends:'
    p get_friends

      #TODO Оптимизировать работу запрос к базе
      db_friends = VkFollower.where( :social_connection_id=>sc.id, :sub=>false).all.map{ |c| c.id_A }

    p db_friends

      return if (get_friends == nil)or(db_friends == nil)

      if db_friends.count != get_friends.count then

        followers_diff = diff_friends( db_friends, get_friends )

    p followers_diff

        update_followers( sc, followers_diff, false)
      end

    #CheckFriends--------------<


    #CheckSubscribe-------------->

      get_subscribers = get_subscribers( sc )

    p 'Подписчики:'
    p get_subscribers

      #TODO Оптимизировать работу запрос к базе
        db_subscribers = VkFollower.where( :social_connection_id=>sc.id, :sub=>true ).all.map{ |c| c.id_A }
    p db_subscribers

      return if ( get_subscribers == nil )or( db_subscribers == nil )

      if db_subscribers.count != get_subscribers.count then

        followers_diff = diff_friends( db_subscribers, get_subscribers )
    p followers_diff

        update_followers( sc,followers_diff, true )
      end

    #CheckSubscribe--------------<

    end

  end



#--begin-->

  threads = []

  threads << Thread.new do
    Vk_folowers.init
    first=Vk_folowers.new
    first.start
  end

sleep 5

  threads << Thread.new do
    avatars_update_loop=Vk_avatars.new
  end

  threads.each {|thr| thr.join }

