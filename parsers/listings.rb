require "./lib/helper"

parse = false

vars = page['vars']

if page['response_status_code']
    if (page['response_status_code'] == 404 or page['response_status_code'] == 308 or page['response_status_code'] == 307)
        if page['refetch_count'] < 3
            refetch page['gid']
        else
            outputs << {
                "_collection"=> "product_not_available_on_category",
                "url"=>page['url'],
                "category"=> vars['cat'],
                "sub_category"=>vars['sub_cat'],
            }
        end
    else
        parse = true
    end
elsif page['failed_response_status_code']
    if page['refetch_count'] < 3
        refetch page['gid']
    else
        outputs << {
            "_collection"=> "product_not_available_on_category",
            "url"=>page['url'],
            "category"=> vars['cat'],
            "sub_category"=>vars['sub_cat'],
        }
    end
end



if parse
    html = Nokogiri::HTML(content)

    article = html.at_css('article')
    store = JSON.parse(article.text) rescue nil
    script = html.at("script#__NEXT_DATA__")
    json_script = JSON.parse(script)

    File.write("Product.json", JSON.dump(json_script))

    store_front = page['url'].gsub('https://www.rappi.com.ar/tiendas', "storefront")
    
    json_data = json_script['props']['pageProps']['fallback'][store_front]['aisle_detail_response']['data']['components'] rescue nil
    json_data ||= json_script['props']['pageProps']['fallback'][store_front]['sub_aisles_response']['data']['components']
    category_id = json_script['props']['pageProps']['fallback'][store_front]['aisle_detail_response_extras']['aisle']['parent_id']
    i = 1

    unless json_data.nil? 
        json_data.each do |json|
            products = json['resource']['products']
            subcat = vars['sub_cat']
            
            products.each do |product|
                
                pd  = Helper.parseProduct(product, store, subcat, vars, i)
                pd['barcode'] = product['master_product_id']
                pd['category_id'] = product['category_id']
                pd['category_id_parent'] = category_id #category_id
                pd['scraped_at_timestamp'] = (ENV['reparse'] == "1" ? (Time.parse(page['fetched_at']) + 1).strftime('%Y-%m-%d %H:%M:%S') : Time.parse(page['fetched_at']).strftime('%Y-%m-%d %H:%M:%S'))

                outputs << pd

                i = i+1
            end    
        end
    end
end

