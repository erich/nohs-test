require_relative 'item'
require_relative 'promotional_code'

class Checkout

  attr_accessor :scanned_items
  attr_reader   :promotional_code

  def initialize(promotional_code)
    @promotional_code = promotional_code
    @scanned_items = Array.new
  end
  
  def scan(item)
    scanned_items << item 
  end
  
  def total
    "£#{round_calculated_total_price}"
  end

  def calculate_total_price
    promotional_code.items = scanned_items
    promotional_code.total_price_after_item_price_reduction
    promotional_code.total_price_before_reduction = scanned_items.collect(&:price).inject(:+)
    promotional_code.total_price_after_percentage_reduction
  end

  def round_calculated_total_price
    calculate_total_price.round(2)
  end
  
end
