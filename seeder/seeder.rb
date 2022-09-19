require './lib/headers'

lat = ENV['location_lat']
lng = ENV['location_lng']

## USING WEB API
body = '{"dynamic_list_request":{"limit":10,"offset":0,"context":"store_home","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"185340-turbo-aab"}}'
to_queue = {
    url: "https://services.rappi.com.ar/api/ms/web-proxy/dynamic-list/cpgs/",
    page_type: 'aisle',
    body: body,
    method: 'POST',
    headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
    vars: {
        offset: 0,
    }
}
require 'securerandom'
uuid = SecureRandom.uuid
pages << {
    url: "https://services.rappi.com.ar/api/rocket/v2/guest/passport/",
    page_type: 'get_passport',
    method: 'GET',
    priority: 100,
    driver: {'name' => "#{to_queue['page_type']}_#{to_queue['url']}"},
    headers: {
        "user-agent"=> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome",
        "accept"=> "*/*",
        "accept-encoding"=> "gzip, deflate, br",
        "deviceid" => uuid,
        "origin" => "https://www.rappi.com.ar/",
        "referer" => "https://www.rappi.com.ar/",
    },
    vars: {
        to_queue: to_queue,
    }
}