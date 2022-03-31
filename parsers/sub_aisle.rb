require './lib/headers'
lat = ENV['location_lat']
lng = ENV['location_lng']

json = JSON.parse(content)

vars = page['vars']

aisle_list = json['dynamic_list_response']['data']['components']
next_offset = json['dynamic_list_response']['data']['offset']

unless aisle_list.empty?
    unless aisle_list[0]['resource'].nil?
        aisle_list.each do |aisle|
            sub_aisle = aisle['resource']['friendly_url']
            body = '{"dynamic_list_request":{"limit":10,"offset":0,"context":"aisle_detail","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"185340-turbo-aab","aisle_friendly_url":"'+vars['aisle_url']+'","subaisle_friendly_url":"'+sub_aisle+'"}}'
            pages << {
                url: "https://services.rappi.com.ar/api/ms/web-proxy/dynamic-list/cpgs/",
                page_type: 'product',
                body: body,
                method: 'POST',
                headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
                vars: {
                    offset: 0,
                    aisle_url: vars['aisle_url'],
                }
            }
        end

        # NEXT AISLE LIST
        if vars['offset'] < next_offset
            body = '{"dynamic_list_request":{"limit":10,"offset":'+next_offset.to_s+',"context":"sub_aisles","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"185340-turbo-aab","aisle_friendly_url":"'+vars['aisle_url']+'"}}'
            pages << {
                url: "https://services.rappi.com.ar/api/ms/web-proxy/dynamic-list/cpgs/",
                page_type: 'sub_aisle',
                body: body,
                method: 'POST',
                headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
                vars: {
                    offset: next_offset,
                    aisle_url: vars['aisle_url'],
                }
            }
        end
    end
end