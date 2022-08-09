html = Nokogiri::HTML(content)

# if !content.include?('Producto no disponible')
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
        # require 'byebug'
        # byebug
        prod_friendly_url = "/p/#{prod_body['query']['master_product_friendly_url']}/-34.5887308--58.4302191"
        if !prod_body['props']['pageProps']['fallback'].nil?
            product = prod_body['props']['pageProps']['fallback'][prod_friendly_url]['master_product_detail_response']['data']['components'][0]['resource']['product']
        else
            product = prod_body['props']['pageProps']['product_detail_response']['data']['components'][0]['resource']['product']
        end
        # require 'byebug'
        # byebug
        description = product['description']
        if !brand_body['brand'].nil?
            brand = brand_body['brand']['name'] rescue nil
        end
        name = product['name']
        category_id = product['category_id']
        category = vars['aisle_url'].gsub('-',' ')
        subcategory_name = product['category_name']
        # currency_code_lc = brand_body['offers']['priceCurrency']
        if !brand_body['offers'].nil?
            currency_code_lc = brand_body['offers']['priceCurrency']
            availability = brand_body['offers']['availability']
            prod_url = brand_body['offers']['url']
        else
            prod_url = page['url']
            currency_code_lc = brand_body['estimatedCost']['currency']
        end
        store_id = product['store_id']
        competitor_product_id = product['id']

        image_url = brand_body['image']['url'] rescue nil
        image_url ||= brand_body['image'] rescue nil

        sku = brand_body['sku'] rescue nil
        # prod_url = brand_body['offers']['url']
        # availability = brand_body['offers']['availability']

        attributes = product['attributes'].nil? ? nil : product['attributes'].map {|map| map}.first
        unless attributes.nil?
            item_attributes = {
                "tags": "#{attributes.map {|map| "'#{map}'"}.join(', ')}"
            }.to_json
        end

        if !product['presentation'].nil?
            if product['presentation'].include? ('X')
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
                    /(\d*[\.,]?\d+)\s?([Cc][Cc])/i,
                    /(\d*[\.,]?\d+)\s?([Mm][Tt])/i,
                    /(\d*[\.,]?\d+)\s?([Cc][Mm])/i,
                    /(\d*[\.,]?\d+)\s?([Uu]nd)/i,
                    /(\d*[\.,]?\d+)\s?([Mm])/i,
                ]
                regexps.find {|regexp| product['presentation'] =~ regexp}
                item_size = $1
                uom = $2

                product_pieces = ''
                regexps_pack = [
                    /(\d+)\s?[Xx]./i,
                ]
                regexps_pack.find {|regexp| product['presentation'] =~ regexp}
                product_pieces = $1

                if product['quantity'] == '0'
                    product_pieces = '1'
                    regexps = [
                        /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
                        /(\d*[\.,]?\d+)\s?(Hojas)/,
                    ]
                    regexps.find {|regexp| product['name'] =~ regexp}
                    item_size = $1
                    uom = $2
                end
            else
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
                    /(\d*[\.,]?\d+)\s?([Cc][Cc])/i,
                    /(\d*[\.,]?\d+)\s?([Mm][Tt])/i,
                    /(\d*[\.,]?\d+)\s?([Cc][Mm])/i,
                    /(\d*[\.,]?\d+)\s.([Uu]nd)/i,
                    /(\d*[\.,]?\d+)\s?([Mm])/i,
                ]
                regexps.find {|regexp| product['presentation'] =~ regexp}
                item_size = $1
                uom = $2

                product_pieces = '1'

                if product['quantity'] == '0'
                    product_pieces = '1'
                    regexps = [
                        /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
                        /(\d*[\.,]?\d+)\s?(Hojas)/,
                    ]
                    regexps.find {|regexp| product['name'] =~ regexp}
                    item_size = $1
                    uom = $2
                end
            end

            product_pieces = '1' if product_pieces.nil? || product_pieces.empty?
            if item_size.nil?
                regexps = [
                    /(\d*[\.,]?\d+)/
                ]
                regexps.find {|regexp| product['presentation'] =~ regexp}
                item_size = $1
            end
        end
        # if item_size.nil?
        #     regexps = [
        #         /(\d*[\.,]?\d+)/
        #     ]
        #     regexps.find {|regexp| product['presentation'] =~ regexp}
        #     item_size = $1
        # end

        # promo_attributes = ''
        # if product['have_discount'] == true
        #     promo_attributes = {
        #         "promo_detail": "'#{html.css('.sc-ifAKCX.iemudu.sc-630d76da-9.davlYg').text.strip} off'"
        #     }.to_json
        # else
        #     promo_attributes = {
        #         "promo_detail": ""
        #     }.to_json
        # end

        customer_price_lc = ''
        base_price = ''
        has_discount = false
        is_promoted = false
        percentage = ''
        unless product['price'].nil?
            if vars['real_price'] != vars['price']
                customer_price_lc = vars['price']
                base_price = vars['real_price']
                has_discount = true
                is_promoted = true
                percentage = (((base_price - customer_price_lc)/base_price.to_f)*100).to_f.round(7).to_s
            else
                customer_price_lc = vars['price']
                base_price = vars['price']
            end
        end

        promo_attributes = ''
        if !percentage.nil? || !percentage.empty?
            promo_attributes = {
                "promo_detail": "'#{percentage.gsub(/\..*/,'')}% off'"
            }.to_json
        else
            promo_attributes = {
                "promo_detail": ""
            }.to_json
        end

        reviews = {"num_total_review":0, "avg_rating":0}.to_json
        if !brand.nil? and brand.include? ('Turbo')
            is_private_label = false
        else
            is_private_label = true
        end
        # require 'byebug'
        # byebug
        outputs << {
            '_collection' => 'items',
            '_id' => prod_url,
            'competitor_name' => 'Rappi Turbo',
            'competitor_type' => 'dmart',
            'store_name' => "Turbo Fresh",
            'store_id' => store_id,
            'country_iso' => 'AR',
            'language' => 'ESP',
            'currency_code_lc' => 'ARS',
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
            'is_private_label' => brand.nil? || brand.empty? ? nil : is_private_label,
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
# end