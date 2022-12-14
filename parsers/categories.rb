html = Nokogiri::HTML(content)

categories = html.css(".lioYQK ul li.ldHzLE")

categories.each_with_index do |category, idx|
    cat = category.at_css("h3[data-testid=\"typography\"]")
    subcategories = category.css('ul li a')

    if subcategories.empty?
        pages << {
            page_type: "listings",
            url: "https://www.rappi.com.ar#{cat.attr('href')}",
            headers: page['headers'],
            no_redirect: true,
            vars: {
                cat: cat.text,
                sub_cat: nil,
                page_number: 1
            }
        }
    end

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
end