require_relative 'percentage_price_reduction'
require_relative 'item_price_reduction'

class PromotionalCode
  attr_accessor :total_price_before_reduction, :items

  def total_price_after_percentage_reduction(percentage_price_reduction = PercentagePriceReduction) 
    percentage_price_reduction.new(total_price_before_reduction).total_price_after_percentage_reduction
  end


  def total_price_after_item_price_reduction(item_price_reduction = ItemPriceReduction)
    item_price_reduction.new(items, {product_code_for_reduced_item: 0001, price_for_reduced_item: 8.50, number_of_items_for_promotion: 2}).total_price_after_item_price_reduction
  end

end
