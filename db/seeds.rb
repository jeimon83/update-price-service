# frozen_string_literal: true

products_data = [
  { name: 'Medium Coverage',         sell_in: 10,      price: 20 },
  { name: 'Full Coverage',           sell_in: 2,       price: 0 },
  { name: 'Low Coverage',            sell_in: 5,       price: 7 },
  { name: 'Mega Coverage',           sell_in: 0,       price: 80 },
  { name: 'Mega Coverage',           sell_in: -1,      price: 80 },
  { name: 'Special Full Coverage',   sell_in: 15,      price: 20 },
  { name: 'Special Full Coverage',   sell_in: 10,      price: 49 },
  { name: 'Special Full Coverage',   sell_in: 5,       price: 49 },
  { name: 'Super Sale',              sell_in: 3,       price: 6 }
]

puts '######## Creating Products...'
products_data.each do |product_data|
  puts "-> #{product_data[:name]}"
  Product.create!(product_data)
end
