require './lib/headers'

lat = ENV['location_lat']
lng = ENV['location_lng']

## USING WEB API
body = '{"dynamic_list_request":{"limit":10,"offset":0,"context":"store_home","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"185340-turbo-aab"}}'
pages << {
    url: "https://services.rappi.com.ar/api/ms/web-proxy/dynamic-list/cpgs/",
    page_type: 'aisle',
    body: body,
    method: 'POST',
    headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
    vars: {
        offset: 0,
    }
}