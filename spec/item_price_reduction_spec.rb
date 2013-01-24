require_relative 'spec_helper'
require_relative '../lib/item_price_reduction'
require_relative '../lib/item'

describe ItemPriceReduction do
  
  let(:item) { Item.new(product_code: 0001, price: 10) }
  let(:items) { [item, item, item] }
  subject { ItemPriceReduction.new(items, {product_code_for_reduced_item: 0001, price_for_reduced_item: 8.50, number_of_items_for_promotion: 2}) }

  it 'changes price pro item' do
    subject.change_price_for_item(item).must_equal 8.50
  end

  it 'reduces price for 3 items' do
    subject.items = items
    subject.total_price_after_item_price_reduction.first.price.must_equal 8.50
    subject.total_price_after_item_price_reduction.last.price.must_equal 8.50
  end

  it 'doesn\'t reduce price if there is only one item with reduced price' do
    subject.items = [item]
    subject.total_price_after_item_price_reduction.first.price.must_equal 10
  end

end
