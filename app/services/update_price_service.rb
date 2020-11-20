# frozen_string_literal: true

class UpdatePriceService
  def initialize(total_days)
    @report = []
    @day = 1
    @total_days = total_days
    @normal_speed = 1
    @double_speed = 2
    @triple_speed = 3
  end

  def self.start(total_days)
    new(total_days).run
  end

  def run
    while @day <= @total_days
      process_products
      @day += 1
    end

    final_report
  end

  private

  def process_products
    Product.all.find_each do |product|
      @product = product
      update_product_price
      include_product_in_report
    end
  end

  def update_product_price
    case @product.name.downcase
    when 'medium coverage'        then medium_coverage
    when 'full coverage'          then full_coverage
    when 'low coverage'           then low_coverage
    when 'special full coverage'  then special_full_coverage
    when 'super sale'             then super_sale
    end
  end

  def medium_coverage
    remaining_days = @product.sell_in - @normal_speed
    value = remaining_days.negative? ? @double_speed : @normal_speed
    new_price = @product.price - value
    new_price = 0 if new_price.negative?
    update_product(remaining_days, new_price)
  end

  def full_coverage
    remaining_days = @product.sell_in - @normal_speed
    value = remaining_days.negative? ? @double_speed : @normal_speed
    new_price = @product.price + value
    update_product(remaining_days, new_price)
  end

  def low_coverage
    remaining_days = @product.sell_in - @normal_speed
    new_price = @product.price - @normal_speed
    new_price = 0 if remaining_days.negative? || new_price.negative?
    update_product(remaining_days, new_price)
  end

  def special_full_coverage
    remaining_days = @product.sell_in - @normal_speed
    value = price_speed(remaining_days)
    new_price = @product.price + value
    new_price = new_price > 50 ? 50 : new_price
    new_price = 0 if remaining_days.negative?
    update_product(remaining_days, new_price)
  end

  def super_sale
    remaining_days = @product.sell_in - @normal_speed
    value = remaining_days.negative? ? @double_speed : @normal_speed
    new_price = @product.price - value
    new_price = 0 if new_price.negative?
    update_product(remaining_days, new_price)
  end

  def price_speed(remaining_days)
    if remaining_days > 9
      @normal_speed
    elsif remaining_days.between?(5, 9)
      @double_speed
    elsif remaining_days < 5
      @triple_speed
    end
  end

  def update_product(remaining_days, new_price)
    @product.update(sell_in: remaining_days, price: new_price)
  end

  def include_product_in_report
    @report << reloaded_product
  end

  def reloaded_product
    @product.reload
  end

  def final_report
    day = 1
    @report.each_slice(batch_quantity) do |products_batch|
      print_product_attributes(day, products_batch)
      day += 1
    end
    'ComparaOnline Interview Coding Test'
  end

  def print_product_attributes(day, products_batch)
    puts "-------- day #{day} --------"
    puts 'name, sell_in, price'
    products_batch.each do |product|
      puts "#{product.name}, #{product.sell_in}, #{product.price}"
    end
    puts ''
  end

  def batch_quantity
    Product.count
  end
end
