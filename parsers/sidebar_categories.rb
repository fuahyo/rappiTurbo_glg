require "./lib/helper"

html = Nokogiri::HTML(content)
vars = page['vars']

categories = html.css('div[data-qa="slider"]')
parser = false

if categories.count > 0
    categories.each do |cat|
       
        subcat = cat.at_css('.sliderDesktop h2[data-testid="typography"]').text.strip
        url = ["https://www.rappi.com.ar",cat.at_css('.sliderDesktop a[data-testid="link"]')['href']].join('') rescue nil
        if url
            pages << {
                page_type: "listings",
                url: url,
                headers: page['headers'],
                no_redirect: true,
                vars: vars.merge("sub_cat"=>subcat)
            }
        else
            parser = true
        end
    end
else
    outputs << {
        _collection: "sidebar_cat_dont_have_subcat",
        vars: vars
    }
end

if parser
    article = html.at_css('article')
    store = JSON.parse(article.text)
    script = html.at("script#__NEXT_DATA__")
    json_script = JSON.parse(script)

    i = 1

    store_front = page['url'].gsub('https://www.rappi.com.ar/tiendas', "storefront")

    json_data = json_script['props']['pageProps']['sub_aisles_response']['data']['components'] rescue nil
    json_data = json_script['props']['pageProps']['fallback'][store_front]['sub_aisles_response']['data']['components'] if json_data.nil?
    json_data.each do |json|
        products = json['resource']['products']
        subcat = json['resource']['name']
        products.each do |product|
            pd  = Helper.parseProduct(product, store, subcat,vars, i)
            outputs << pd

            i = i+1
        end
    end
end