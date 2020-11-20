# frozen_string_literal: true

class Product < ApplicationRecord
  def self.update_price_service
    print 'Insert Total Days: '
    total_days = gets.strip
    return 'Total Days cant be a string, zero or negative' if total_days.to_i.zero? || total_days.to_i.negative?

    prepare_database
    UpdatePriceService.start(total_days.to_i)
  end

  private_class_method def self.prepare_database
    delete_all_products
    Rails.application.load_seed
  end

  private_class_method def self.delete_all_products
    Product.delete_all
  end
end
