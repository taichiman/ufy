require 'oa-oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
# provider :twitter, 'VVvrpKu7KPNP52jFaF0LvA', 'uRq12ri2Vl6P2a9ltQbyD5aEGw8MHGi5gd6Gbijk2I' - мой
  provider :facebook, '269751959719529', '	b8ca46077df3b595bcb4a8868a888836'


  #**************
  provider :vkontakte, '2476144', 'J1PIH30J4mkceUpTAdmg',  {:scope => "friends messages offline"}
  OpenSSL::SSL::VERIFY_PEER=OpenSSL::SSL::VERIFY_NONE
  #**************

#  #**************
#  provider :vkontakte, '2476144', 'J1PIH30J4mkceUpTAdmg',  {:redirect_uri => "http://localhost:3000", :scope => "friends notify docs notes pages offers questions wall groups ads"}
#  OpenSSL::SSL::VERIFY_PEER=OpenSSL::SSL::VERIFY_NONE
#  #**************
##,,photos,audio,video, ,,,,,,,
#notify,friends,photos,audio,video,docs,notes,pages,offers,questions,wall,groups,messages,ads
#offline


end

