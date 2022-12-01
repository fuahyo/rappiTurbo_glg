html = Nokogiri::HTML(content)

categories = html.css(".fVQdrF ul li")
i = 1

categories.each do |category|
    
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
            page_number: 1
        }
    }
end