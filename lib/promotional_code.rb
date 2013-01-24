class PromotionalCode
  attr_accessor :total_price_before_reduction, :items

  def over_price
    60
  end

  def percentage_reduction(by_how_many_percents = 10)
    total_price_before_reduction - ((total_price_before_reduction.to_f / 100) * by_how_many_percents)
  end

  def total_price_after_percentage_reduction 
    return total_price_before_reduction if total_price_before_reduction <= over_price
    percentage_reduction
  end

  def product_code_for_reduced_item
    0001
  end

  def price_for_reduced_item
    8.50
  end

  def change_price_for_item(item)
    item.price = price_for_reduced_item
  end

  def total_price_after_item_price_reduction
    select_items_for_reduction.map {|item| change_price_for_item(item) } if select_items_for_reduction.size > 1
    items
  end

  private
  def select_items_for_reduction
    items.select {|item| item.product_code == product_code_for_reduced_item}
  end
end
