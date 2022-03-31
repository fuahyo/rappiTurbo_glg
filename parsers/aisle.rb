require './lib/headers'
lat = ENV['location_lat']
lng = ENV['location_lng']

json = JSON.parse(content)

vars = page['vars']

# body = '{"dynamic_list_request":{"limit":10,"offset":0,"context":"sub_aisles","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"900066652-turbo-express-santiago","aisle_friendly_url":"frutas-y-verduras"}}'
# pages << {
#     url: "https://services.rappi.cl/api/ms/web-proxy/dynamic-list/cpgs/",
#     page_type: 'sub_aisle',
#     body: body,
#     method: 'POST',
#     headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
#     vars: {
#         offset: 0,
#         aisle_url: 'frutas-y-verduras',
#     }
# }
## FULL RUN ##
aisle_list = json['dynamic_list_response']['data']['components']
next_offset = json['dynamic_list_response']['data']['offset']

unless aisle_list.empty?
    unless aisle_list[0]['resource'].nil?
        aisle_list.each do |aisle|
            if aisle['name'] == 'aisles'
                aisle_url = aisle['resource']['friendly_url']
                body = '{"dynamic_list_request":{"limit":10,"offset":0,"context":"sub_aisles","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"185340-turbo-aab","aisle_friendly_url":"'+aisle_url+'"}}'
                pages << {
                    url: "https://services.rappi.com.ar/api/ms/web-proxy/dynamic-list/cpgs/",
                    page_type: 'sub_aisle',
                    body: body,
                    method: 'POST',
                    headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
                    vars: {
                        offset: 0,
                        aisle_url: aisle_url,
                    }
                }
            end
        end

        # NEXT AISLE LIST
        if vars['offset'] < next_offset
            body = '{"dynamic_list_request":{"limit":10,"offset":'+next_offset.to_s+',"context":"store_home","state":{"lat":"'+lat.to_s+'","lng":"'+lng.to_s+'"}},"dynamic_list_endpoint":"context/content","proxy_input":{"seo_friendly_url":"185340-turbo-aab"}}'
            pages << {
                url: "https://services.rappi.com.ar/api/ms/web-proxy/dynamic-list/cpgs/",
                page_type: 'aisle',
                body: body,
                method: 'POST',
                headers: ReqHeaders::SEARCH_PAGE_HEADER_REQ,
                vars: {
                    offset: next_offset,
                }
            }
        end
    end
end