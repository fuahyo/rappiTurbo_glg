html = Nokogiri::HTML(content)
script = html.at("script#__NEXT_DATA__")
json_script = JSON.parse(script)

store_front = page['url'].gsub('https://www.rappi.com.ar/tiendas', "storefront").gsub('catalogo','catalog')
cat_list = json_script['props']['pageProps']['fallback'][store_front]['catalog_response']['data']['components']

categories = html.css("div.sc-fce1e844-2.bkOKsD ul a")
categories.each_with_index do |category, idx|
    subcategories = category.css('ul li a')
    cat_name = category.text
    cat_id = ''
    cat_list.each do |cat|
        if cat['state']['name'] == cat_name
            cat_id = cat['state']['parent_id']
        end
    end
    
    if subcategories.empty?
        pages << {
            page_type: "sidebar_categories",
            url: "https://www.rappi.com.ar#{category.attr('href')}",
            headers: page['headers'],
            no_redirect: true,
            vars: {
                cat: category.text,
                cat_id: cat_id,
                sub_cat: nil,
                page_number: 1
            }
        }
    end
end