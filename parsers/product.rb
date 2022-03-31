require './lib/headers'
lat = ENV['location_lat']
lng = ENV['location_lng']

json = JSON.parse(content)

vars = page['vars']

components = json['dynamic_list_response']['data']['components']
components.each do |component|
    products = component['resource']['products']
    products.each_with_index do |prod, i|
        url = "https://www.rappi.cl/producto/" + prod["id"]
        pages << {
            url: url,
            method: "GET",
            page_type: "details",
            driver: {
                name: "#{url}_#{rand()}"
            },
            vars: {
                rank: i+1,
                page_num: 1,
                aisle_url: vars['aisle_url']
            }
        }
    end

end