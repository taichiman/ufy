module Vk_HTTP



def Vk_HTTP.write_logs( file_name, str, title = "")
  f=File.open( file_name ,'a') do |f|
    f.puts title+' '+title+' '+title
    f.puts Time.now
    f.puts str
    f.puts "***\n"
  end
end


  #\
  #
  # request_api(url)
  #
  #
  # request_api(url) -> nil       error
  # request_api(url) -> {response} JSON
  #
  # Запросит API, обработает ошибки.
  #
  #/

  def Vk_HTTP.request_api(url)

    err_count = 0

    loop do

      if err_count>10 # 10 попыток, при ошибке в ответе
        puts '10 API Errors responds  now !!! Something is bad.'
        print "\a"
   return nil
      end

      response = JSON.parse(open(url).read)
      write_logs("./vk_all_request.log", response)

      if response.key?('response') && response['response'].kind_of?(Array) #валидация запроса friends.get и getProfiles
   return response['response']

      elsif response.key?('response') && response['response'].key?('count') && response['response'].key?('users')   #валидация запроса subscriptions.getFollowers
   return response['response']

      elsif response.key?('error')
        p "Errors #{response}"
        write_logs("./vk_request_errors.log", response)
        err_count += 1

      else
        puts 'Unknown API response !'; p "\a"
        write_logs("./vk_request_errors.log", response,"Unknown API response")
        err_count += 1
      end
    end

  end
end

