require './lib/headers'
lat = ENV['location_lat']
lng = ENV['location_lng']

json = JSON.parse(content)

vars = page['vars']

components = json['dynamic_list_response']['data']['components']
components.each do |component|
    products = component['resource']['products']
    products.each_with_index do |prod, i|
        real_price = prod['real_price']
        price = prod['price']
        url = "https://www.rappi.com.ar/producto/" + prod["id"]
        pages << {
            url: url,
            method: "GET",
            page_type: "details",
            driver: {
                name: "#{url}"
            },
            vars: {
                rank: i+1,
                page_num: 1,
                aisle_url: vars['aisle_url']
                real_price: real_price,
                price: price
            }
        }
    end

end