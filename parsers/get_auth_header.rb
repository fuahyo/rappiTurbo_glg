
to_queue = page['vars']['to_queue']
if page['failed_response_status_code'] == 401 

    require 'securerandom'
    uuid = SecureRandom.uuid
    pages << {
        url: "https://services.rappi.com.ar/api/rocket/v2/guest/passport/",
        page_type: 'get_passport',
        method: 'GET',
        priority: 100,
        driver: {'name' => "#{page['driver']['name']}_r"},
        headers: {
            "user-agent"=> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome",
            "accept"=> "*/*",
            "accept-encoding"=> "gzip, deflate, br",
            "deviceid" => uuid,
            "origin" => "https://www.rappi.com.ar/",
            "referer" => "https://www.rappi.com.ar/",
        },
        vars: page['vars']
    }

else

    auth_header = JSON.parse(content)["access_token"]

    to_queue['headers']['authorization'] = "Bearer #{auth_header}"
    to_queue['headers']['deviceid'] = page['headers']['deviceid']
    
    pages << to_queue    

end




