class ItemPriceReduction

  attr_accessor :items
  attr_reader :product_code_for_reduced_item, :price_for_reduced_item, :number_of_items_for_promotion

  def initialize(items, item_options)
    @items = items
    @product_code_for_reduced_item = item_options.fetch(:product_code_for_reduced_item)
    @price_for_reduced_item = item_options.fetch(:price_for_reduced_item)
    @number_of_items_for_promotion = item_options.fetch(:number_of_items_for_promotion)
  end

  def change_price_for_item(item)
    item.price = price_for_reduced_item
  end

  def total_price_after_item_price_reduction
    select_items_for_reduction.map {|item| change_price_for_item(item) } if select_items_for_reduction.size >= number_of_items_for_promotion 
    items
  end

  private
  def select_items_for_reduction
    items.select {|item| item.product_code == product_code_for_reduced_item}
  end
end
