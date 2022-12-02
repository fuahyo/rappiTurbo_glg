html = Nokogiri::HTML(content)

categories = html.css(".hrwgsd ul li")
script = JSON.parse(html.at("script#__NEXT_DATA__"))
i = 1

cat_id = ''
categories.each_with_index do |category, idx|
    cat_id = script['props']['pageProps']['fallback']['storefront/185340-turbo-aab/catalog']['catalog_response']['data']['components'][0]['resource']['categories'][idx]['id'] rescue nil
    cat = category.at_css("a[data-testid=\"typography\"]")
    subcategories = category.css('ul li a')

    subcategories.each do |subcategory|
        
        pages << {
            page_type: "listings",
            url: "https://www.rappi.com.ar#{subcategory['href']}",
            headers: page['headers'],
            no_redirect: true,
            vars: {
                cat: cat.text,
                cat_id: cat_id,
                sub_cat: subcategory.text,
                page_number: 1
            }
        }
    end
    
    i = i+1

    pages << {
        page_type: "sidebar_categories",
        url: "https://www.rappi.com.ar#{cat['href']}",
        headers: page['headers'],
        no_redirect: true,
        vars: {
            cat: cat.text,
            cat_id: cat_id,
            page_number: 1
        }
    }
end