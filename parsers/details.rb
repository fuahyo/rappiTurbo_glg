html = Nokogiri::HTML(content)

vars = page['vars']
if page['response_status_code'] == 404
    refetch_count = (page['vars']['refetch_count'].nil?)? 1 : page['vars']['refetch_count'] + 1
    if refetch_count < 30
      pages << {
        url: page['url'],
        page_type: "details",
        method: 'GET',
        headers: {
            'user-agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36",
            "accept"=> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "accept-encoding"=> "gzip, deflate, br",
            "accept-language"=> "en-US,en;q=0.9",
            "cookie" => "Path=/; _gcl_au=1.1.59036847.1649269989; _gid=GA1.2.1067758114.1649269990; ab.storage.deviceId.f6a1117f-52de-444c-9fbd-49d465e7f80e=%7B%22g%22%3A%22e16a9f8a-fae2-a93c-a14b-237563746671%22%2C%22c%22%3A1649269989626%2C%22l%22%3A1649269989626%7D; _fbp=fb.1.1649269995039.1151299560; _hjCachedUserAttributes=eyJhdHRyaWJ1dGVzIjp7IlNpZ25lZCB1cCI6IjIwMTnigJQwNi0yMFoifSwidXNlcklkIjoiQ0xfdW5kZWZpbmVkIn0=; afUserId=8ad19816-17ab-408e-a0fb-2026a462a982-p; _lr_uf_-ttasrx=8e6b28ed-1efc-4aa4-aeff-e5c86c64e363; rappi.id=eyJhY2Nlc3NfdG9rZW4iOiJmdC5nQUFBQUFCaVRkejRSRlhLTVZaazNaYWVSUEVJWnRfWl83c1YtalpzWWhWa3QteHdWUDFkOVFrY3BwcmFBMjBOZTU3dHllM0o2ZWhSNlluT1RfRF84ZDN0cVFYWExmRWZzTXpQdUl0WnJvaGs0ZHd3UU9vYS1zakQzeWkzQUFzWnk2ZHhfWndfT3Rxc001SmR3RHhhMGhLUGh5X0ZEYmg3MFFvMzdCYXVqMjlDd3JpdG5NWC1EWGZTMzFqZ195UVN2Qjk4Q3VoS0xmamFWazN2SWpiVFQ0Z1NaZGhkcmlYUEJfQUZ3SU5SUjk3Z0UySkE2MmV0WG9IOUdURnhGejJRTnIxOTFZblNPWVUwcGJRUWVmc1N3MUhpMUo2MnlOeHlTNmRkel9mWlQzYUdQWm9tX3dJX0dma050dU9DUXVwU1lpTVgtTXk4RmtSNjB0cktKV3VXVVpJZ3ZzbzVFQmtKSk03LXl6NXJSNlI5MHJNMHZtYzR2aUk9IiwidG9rZW5fdHlwZSI6IkJlYXJlciJ9; rappi.type=0; _hjSessionUser_1808620=eyJpZCI6Ijg0MzUyNmQ2LWJmZjEtNTFmMy05NTFhLWZhYzUzZTNkMjVmMiIsImNyZWF0ZWQiOjE2NDkyNjk5OTUwNjAsImV4aXN0aW5nIjp0cnVlfQ==; AF_SYNC=1649270114168; currentLocation=eyJhZGRyZXNzIjoiQ2hpbGUgQXRpZW5kZSwgTW9uZWRhLCBTYW50aWFnbywgQ2hpbGUiLCJzZWNvbmRhcnlMYWJlbCI6Ik1vbmVkYSwgU2FudGlhZ28sIENoaWxlIiwiZGlzdGFuY2VJbkttcyI6NS45LCJwbGFjZUlkIjoiQ2hJSmNZUnI3YXZGWXBZUmhBYi1Jc1ZEWG13IiwicGxhY2VJbmZvcm1hdGlvbiI6bnVsbCwic291cmNlIjoiZ29vZ2xlIiwiaWQiOjEsImRlc2NyaXB0aW9uIjoiIiwibGF0IjotMzMuNDQyNTgyNzk5OTk5OTksImxuZyI6LTcwLjY1NjQzMzk5OTk5OTk5LCJjb3VudHJ5IjoiQ2hpbGUiLCJhY3RpdmUiOnRydWV9; ab.storage.sessionId.f6a1117f-52de-444c-9fbd-49d465e7f80e=%7B%22g%22%3A%22384f5d13-329e-f6c8-a1e2-575685dad42d%22%2C%22e%22%3A1649273327429%2C%22c%22%3A1649269989625%2C%22l%22%3A1649271527429%7D; _ga_F9M84QQ7SW=GS1.1.1649269989.1.1.1649271527.0; _ga=GA1.1.1492067388.1649269990; _ga_FGJHX7E4KW=GS1.1.1649269989.1.1.1649271527.60; _ga_KLC0Z8KSQ7=GS1.1.1649269989.1.1.1649271527.0; _ga_EH4F8E7F7Z=GS1.1.1649269989.1.1.1649271527.60; _lr_hb_-ttasrx%2Frappi-webv={%22heartbeat%22:1649273539765}; deviceid=63290371-f260-4758-ae74-fc4601a57891; amplitude_id_101be7b7fdda892d329579012e8dd69arappi.cl=eyJkZXZpY2VJZCI6IjNkNjcyZDVkLWIzMTUtNGRmOC05MGQ3LTUwZDVjMGU1ZTc2NlIiLCJ1c2VySWQiOm51bGwsIm9wdE91dCI6ZmFsc2UsInNlc3Npb25JZCI6MTY0OTI3NTQ3MDE0MiwibGFzdEV2ZW50VGltZSI6MTY0OTI3NTQ3MDE0MiwiZXZlbnRJZCI6OCwiaWRlbnRpZnlJZCI6MCwic2VxdWVuY2VOdW1iZXIiOjh9; _lr_tabs_-ttasrx%2Frappi-webv={%22sessionID%22:1%2C%22recordingID%22:%225-e7cf040f-2151-44dc-9738-6544bf78c2a4%22%2C%22lastActivity%22:1649275477326}"
        },
        driver: {
            name: "#{page['url']}_#{rand}",
        },
        vars: vars.merge({
            refetch_count: refetch_count
        })
      }
    else
      raise 'Refetch Failed'
    end
else
    prod_body = JSON.parse(html.at('script#__NEXT_DATA__').text)
    brand_body = JSON.parse(html.at('script[type="application/ld+json"]').text)

    product = prod_body['props']['pageProps']['product_detail_response']['data']['components'][0]['resource']['product']

    description = product['description']
    brand = brand_body['brand']['name']
    name = product['name']
    category_id = product['category_id']
    category = vars['aisle_url'].gsub('-',' ')
    subcategory_name = product['category_name']
    currency_code_lc = brand_body['offers']['priceCurrency']
    store_id = product['store_id']
    competitor_product_id = product['id']

    image_url = brand_body['image']
    sku = brand_body['sku']
    prod_url = brand_body['offers']['url']
    availability = brand_body['offers']['availability']

    attributes = product['attributes'].nil? ? nil : product['attributes'].map {|map| map}.first
    unless attributes.nil?
        item_attributes = {
            "tags": "#{attributes.map {|map| "'#{map}'"}.join(', ')}"
        }.to_json
    end

    item_size = ''
    uom = ''
    regexps = [
        /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
        /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
        /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
        /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
        /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
        /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
        /(\d*[\.,]?\d+)\s?([Oo]unce)/,
        /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
        /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
        /(\d*[\.,]?\d+)\s?([Ll])/,
        /(\d*[\.,]?\d+)\s?([Gg])/,
        /(\d*[\.,]?\d+)\s?([Ll]itre)/,
        /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
        /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
        /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
        /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
        /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
        /(\d*[\.,]?\d+)\s?([Cc]hews)/,
        /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
        /(\d*[\.,]?\d+)\s?per\s?([Pp]ack)/i,
        /(\d*[\.,]?\d+)\s?([Kk][Gg])/i,
        /(\d*[\.,]?\d+)\s?([Uu]nd)/i,
    ]
    regexps.find {|regexp| product['presentation'] =~ regexp}
    item_size = $1
    uom = $2

    uom = product['unit_type'] if uom.nil? || uom.empty?
    product_pieces = ''
    # regexps_pack = [
    #     /(\d+)\s+Unidades/i,
    #     /(\d+)\s+latas/i,
    #     /(\d+)\s+un/i,
    #     /(\d+)\s+Red Bull/i,
    #     /(\d+)\s+boites/i,
    #     /(\d+)\s+bouteilles/i,
    #     /(\d+)\s+?[Xx]/i,
    #     /(\d+)[Xx]/i,
    #     /[Xx]\s+?(\d+)/
    # ]
    # regexps_pack.find {|regexp| product['presentation'] =~ regexp}
    product_pieces = product['quantity'].to_s

    # if !product_pieces.nil?
    #     if item_size.include?(' x ')
    #         item_size = item_size.gsub(/(\d+)[Xx]\s+/)
    #     end
    # end
    product_pieces = '1' if product_pieces.nil? || product_pieces.empty?

    promo_attributes = ''
    if product['have_discount'] == true
        promo_attributes = {
            "promo_detail": "'#{html.css('.styles__ProductDiscount-sc-wsd7vq-8.jnfIRv').text.strip} off'"
        }.to_json
    else
        promo_attributes = {
            "promo_detail": ""
        }.to_json
    end

    customer_price_lc = ''
    base_price = ''
    has_discount = false
    is_promoted = false
    percentage = ''
    unless product['price'].nil?
        if product['real_price'] != product['price']
            customer_price_lc = product['price']
            base_price = product['real_price']
            has_discount = true
            is_promoted = true
            percentage = (((base_price - customer_price_lc)/base_price.to_f)*100).to_f.round(7).to_s
        else
            customer_price_lc = product['price']
            base_price = product['price']
        end
    end

    reviews = {"num_total_review":0, "avg_rating":0}.to_json
    # require 'byebug'
    # byebug
    outputs << {
        '_collection' => 'items',
        '_id' => competitor_product_id,
        'competitor_name' => 'Rappi Turbo',
        'competitor_type' => 'Local_Store',
        'store_name' => "Turbo Express Santiago",
        'store_id' => store_id,
        'country_iso' => 'CL',
        'language' => 'ESP',
        'currency_code_lc' => currency_code_lc,
        'scraped_at_timestamp' => Time.now().to_s.gsub(/([+]\S+)/, '').strip,
        'competitor_product_id' => competitor_product_id,
        'name' => name,
        'brand' => brand,
        'category_id' => category_id,
        'category' => category, #don't forget to change this category name
        'sub_category' => subcategory_name,
        'customer_price_lc' => customer_price_lc,
        'base_price_lc' => base_price,
        'has_discount' => has_discount,
        'discount_percentage' => percentage,
        'rank_in_listing' => vars['rank'],
        'page_number'=> vars['page_num'],
        'product_pieces' => product_pieces,
        'size_std' => item_size,
        'size_unit_std' => uom,
        'description' => description,
        'img_url'=> image_url,
        'barcode'=> competitor_product_id,
        'sku'=> sku,
        'url'=> prod_url,
        'is_available' => availability == 'InStock' ? true : false,
        'crawled_source'=> 'WEB',
        'is_promoted' => is_promoted,
        'type_of_promotion' => is_promoted == true ? 'Banner' : nil,
        'promo_attributes'=> is_promoted == false ? nil : promo_attributes,
        'is_private_label' => brand.empty? ? nil : true,
        'latitude' => nil, #prod_body['props']['pageProps']['product_detail_response']['data']['context_info']['store']['lat'].to_s,
        'longitude' => nil, #prod_body['props']['pageProps']['product_detail_response']['data']['context_info']['store']['lng'].to_s,
        'reviews' => nil,
        'store_reviews'=> nil,
        'item_attributes'=> item_attributes == "null" ? '' : item_attributes,
        'item_identifiers'=> ({'barcode': "'#{competitor_product_id}'"}).to_json,
        'country_of_origin'=> nil,
        'variants'=> nil,
    }
end