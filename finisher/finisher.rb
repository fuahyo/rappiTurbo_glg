# per_page = 500
# last_id = ''
# locations = []

# while true
#   query = {
#     '_id' => {'$gt' => last_id},
#     '$orderby' => [{'_id' => 1}]
#   }
#   records = find_outputs("products", query, 1, per_page)

#   records.each do |prod|
#     if prod['category'] == 'Congelados'
#         prod['category_id_parent'] = '2878'
#     elsif prod['category'] == 'Bebidas'
#         prod['category_id_parent_parent'] = '2807'
#     elsif prod['category'] == 'Quesos y fiambres'
#         prod['category_id_parent'] = '2924'
#     elsif prod['category'] == 'Snacks y Galletitas'
#         prod['category_id_parent'] = '2933'
#     elsif prod['category'] == 'Frescos y lácteos'
#         prod['category_id_parent'] = '2882'
#     elsif prod['category'] == 'Bebidas alcohólicas'
#         prod['category_id_parent'] = '2814'
#     elsif prod['category'] == 'Listo para comer'
#         prod['category_id_parent'] = '2905'
#     elsif prod['category'] == 'Tabaco'
#         prod['category_id_parent'] = '2938'
#     elsif prod['category'] == 'Helados y Postres'
#         prod['category_id_parent'] = '3774'
#     elsif prod['category'] == 'Chocolates y Golosinas'
#         prod['category_id_parent'] = '3923'
#     elsif prod['category'] == 'Vinos'
#         prod['category_id_parent'] = '3919'
#     elsif prod['category'] == 'Ofertas'
#         prod['category_id_parent'] = '3773'
#     end
#     outputs << prod

#     save_outputs(outputs) if outputs.count > 99
#   end

#   break if records.nil? || records.count < 1

#   last_id = records.last['_id']
# end

per_page = 500
last_id = ''
items = []

while true
  query = {
    '_id' => {'$gt' => last_id},
    '$orderby' => [{'_id' => 1}]
  }
  records = find_outputs("products", query, 1, per_page)

  records.each do |product|
    # require 'byebug'; byebug
    if product['category_id'] == 137
        product['category'] = "Listo para comer"
    end
    outputs << product

    save_outputs(outputs) if outputs.count > 99
  end

  break if records.nil? || records.count < 1

  last_id = records.last['_id']
end