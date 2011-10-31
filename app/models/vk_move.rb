class VkMove < ActiveRecord::Base
  belongs_to :social_connection

  VK_STAT_RANGE=1.day

#***
#
# Получает статистику о фоловерах
#
# get_followers_statistic( SocailConnection vk_tokens )   hash stat { friends , friends_follower, friends_unfollower, subscribers, subscribers_follower, subscribers_unfollower }
#
# sub = 1 friends
#
# sub = 0 subscriber
#
#***
def self.get_followers_statistic( vk_tokens )
  stat = {}
  vk_tokens.each do |token|
    #TODO Ускорить получение из базы
    stat['friends'] = VkFollower.where( :sub => false, :social_connection_id => token ).count

    #друзья фоловеры
     stat.merge!( unfolowers_output_generate( false, 0, 'friend_followers', token ) )

    #друзья анфоловеры
     stat.merge!( unfolowers_output_generate( false, 1, 'friend_unfollowers', token ) )


    #всего подписчиков
    stat['subscribers'] = VkFollower.where( :sub => true, :social_connection_id => token ).count

    #подписка фоловеры
     stat.merge!( unfolowers_output_generate( true, 0, 'subscriber_followers', token ) )

    #подписка анфоловеры
     stat.merge!( unfolowers_output_generate( true, 1, 'subscriber_unfollowers', token ) )

  end

  stat

end

private

#***
#
# Сформирует статистику о заданном типе фоловеров
#
# unfolowers_output_generate ( sub boolean, status boolean, type string )
#
#
#***

  def self.unfolowers_output_generate ( sub, status, type, token )

    followers = VkMove.where( :sub => false, :social_connection_id => token, :status => 0, :action_time => ( Time.now + 7.hour - 1.day .. Time.now + 7.hour ) )

    ary=[];

    followers.each {|f| ary << f.vk_id  }

    VkUser.fill_users_all_inf( ary )

    stat_temp={}
    stat_temp[type+'_avatar']=VkUser.where( :vk_id => ary)
    stat_temp[type] = followers.count
    stat_temp
  end

end

