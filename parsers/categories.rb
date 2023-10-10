html = Nokogiri::HTML(content)

categories = html.css("div.sc-fce1e844-2.bkOKsD ul a")
categories.each_with_index do |category, idx|
    subcategories = category.css('ul li a')
    if subcategories.empty?
        pages << {
            page_type: "sidebar_categories",
            url: "https://www.rappi.com.ar#{category.attr('href')}",
            headers: page['headers'],
            no_redirect: true,
            vars: {
                cat: category.text,
                sub_cat: nil,
                page_number: 1
            }
        }
    end
end