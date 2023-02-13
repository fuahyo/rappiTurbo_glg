class Helper
    class << self
    
        def size(text)
            text = changeNumber(text)
            size_regex = [
                /(\d*[\.,]?\d+)\s?(litre)/i,
                /(\d*[\.,]?\d+)\s?(litro)/i,
                /(\d*[\.,]?\d+)\s?(ml)/i,
                /\b(\d*[\.,]?\d+)\s?(l)\b/i,
                /(\d*[\.,]?\d+)\s?(g)/i,
                /(\d*[\.,]?\d+)\s?(mg)/i,
                /(\d*[\.,]?\d+)\s?(lt)/i,
                /(\d*[\.,]?\d+)\s?(cm)/i,
                /(\d*[\.,]?\d+)\s?(lm)/i,
                /(\d*[\.,]?\d+)\s?(sobres)/i,
                /(\d*[\.,]?\d+)\s?(sillas)/i,
                /(\d*[\.,]?\d+)\s?(niveles)/i,
                /(\d*[\.,]?\d+)\s?(pares)/i,
                /(\d*[\.,]?\d+)\+?\s?(kg)/i,
                /(\d*[\.,]?\d+)\s?(oz)/i,
                /(\d*[\.,]?\d+)\s?(slice[s]?)/i,
                /(\d*[\.,]?\d+)\s?(sachet[s]?)/i,
                /\d+\s?x\s?(\d*[\.,]?\d+)\s?(s)/i,
                /(\d*[\.,]?\d+)\s?(tablet[s]?)/i,
                /(\d*[\.,]?\d+)\s?(tab[s]?)/i,
                /(\d*[\.,]?\d+)\s?(catridge[s]?)/i,
                /(\d*[\.,]?\d+)\s?(sheet[s]?)/i,
                /(\d*[\.,]?\d+)\s?(stick[s]?)/i,
                /(\d*[\.,]?\d+)\s?(bottle[s]?)/i,
                /(\d*[\.,]?\d+)\s?(caplet[s]?)/i,
                /(\d*[\.,]?\d+)\s?(roll[s]?)/i,
                /(\d*[\.,]?\d+)\s?(tip[s]?)/i,
                /(\d*[\.,]?\d+)\s?(bundle[s]?)/i,
                /(\d*[\.,]?\d+)\s?(pair[s]?)/i,
                /(\d*[\.,]?\d+)\s?(set)/i,
                /(\d*[\.,]?\d+)\s?(kit)/i,
                /(\d*[\.,]?\d+)\s?(pc[s]?)/i,
                /(\d*[\.,]?\d+)\s?(box)/i,
                /(\d*[\.,]?\d+)\s?(bag)[^A-Za-z]?/i,
                /(\d*[\.,]?\d+)\s?(unidades)/i,
            ]
            size_regex.find {|sr| text =~ sr}
            std = $1
            unit_std = $2
            size_std = std.gsub(',','').to_f rescue nil
            size_unit_std = unit_std
            [size_std, size_unit_std]
        end

        def changeNumber(text)
            new_text = text.clone
            {
                "six"=>"6",
                "twelve"=>"12",
            }.each do |k, v|
                new_text = new_text.downcase.gsub(k,v)
            end
            new_text
        end

        def productPieces(text)
            text = changeNumber(text)
            product_pieces_regex = [
                /(\d+)\s?per\s?pack/i,
                /(\d+)\s?pack/i,
                /(\d+)\s?pcs?/i,
                /(\d+)\s?x\s?\d+/i,
                /x\s?(\d+)/i,
                /(\d+)\s?hojas/i,
                /(\d+)\s?piezas/i,
                /(\d+)\s?unid/i,
                /(\d+)\s?u/i,
            ].find {|ppr| text =~ ppr}
            product_pieces = product_pieces_regex ? $1.to_i : 1
            product_pieces = 1 if product_pieces == 0
            product_pieces ||= 1
            product_pieces
        end

        def parseProduct(product, store, subcat, vars, rank)
            competitor_product_id = product['id']
            name = product['name']
            brand = product['trademark']
            category_id = nil
            category = vars['cat']
            sub_category = subcat
            customer_price_lc = product['price'].to_f
            base_price_lc = product['real_price'].to_f
            has_discount = false
            discount_percentage = nil
            is_promoted = false
            type_of_promotion = nil
            promo_attributes = nil

            if customer_price_lc < base_price_lc
                has_discount = true
                discount_percentage = (((base_price_lc - customer_price_lc) / base_price_lc) * 100).round(7)
                is_promoted = true
                type_of_promotion = "Banner"
                promo_attributes = {
                    promo_detail: "'#{discount_percentage.ceil}% off'"
                }.to_json
            end
            
            size_std, size_unit_std = Helper.size(name)

            if size_unit_std
                size_unit_std = size_unit_std.downcase
            end

            product_pieces = Helper.productPieces(name)

            uom = product['presentation']

            if size_std.nil? or size_unit_std.nil?
                size_std, size_unit_std = Helper.size(uom)
            end

            if product_pieces == 1
                product_pieces = Helper.productPieces(uom)
            end

            description = product['description']
            is_private_label = brand.empty? ? nil : !(brand.downcase.include?("rappi"))
            
            img_url = nil

            if product['images']
                img_url = "https://images.rappi.com.ec/products/#{product['images'].first}"
            end
            
            barcode = competitor_product_id
            sku = product['product_id']
            product_url = "https://www.rappi.com.ar/p/#{name.downcase.gsub(' ','-').gsub('/', '')}-#{product['master_product_id']}"
            is_available = product['in_stock']
            latitude = store['geo']['latitude'] rescue -0.174505
            longitude = store['geo']['longitude'] rescue -78.48359

            item_attributes = nil
            item_identifiers = JSON.generate({
                "barcode" => "'#{barcode}'"
            })

            pd = {
                _id: competitor_product_id,
                _collection: "products",
                competitor_name: "Rappi Turbo",
                competitor_type: "dmart",
                store_name: "Turbo Fresh",
                store_id: product['store_id'],
                country_iso: "AR",
                language: "ESP",
                currency_code_lc: "ARS",
                scraped_at_timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                competitor_product_id: competitor_product_id,
                name: name,
                brand: brand,
                category_id: category_id,
                category: category,
                sub_category: sub_category,
                customer_price_lc: customer_price_lc,
                base_price_lc: base_price_lc,
                has_discount: has_discount,
                discount_percentage: discount_percentage,
                rank_in_listing: rank,
                page_number: vars['page_number'],
                product_pieces: product_pieces,
                size_std: size_std,
                size_unit_std: size_unit_std,
                description: description,
                img_url: img_url,
                barcode: barcode,
                sku: sku,
                url: product_url,
                is_available: is_available,
                crawled_source: "WEB",
                is_promoted: is_promoted,
                type_of_promotion: type_of_promotion,
                promo_attributes: promo_attributes,
                is_private_label: is_private_label,
                latitude: nil,
                longitude: nil,
                reviews: nil,
                store_reviews: nil,
                item_attributes: item_attributes,
                item_identifiers: nil,
                country_of_origin: nil,
                variants: nil,
                uom: uom,
            }
        end

    end
end