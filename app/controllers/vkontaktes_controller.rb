class VkontaktesController < ApplicationController

  def index

    vk_networks = Network.find_by_name( 'vkontakte' )
    vk_tokens = SocialConnection.where("network_id='#{vk_networks.id}'")

    @stat = VkMove.get_followers_statistic( vk_tokens )

    @cur_user=current_user.id

  end

end

