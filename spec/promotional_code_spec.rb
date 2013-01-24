require_relative 'spec_helper'
require_relative '../lib/promotional_code'
require_relative '../lib/item'

describe PromotionalCode do
  
  subject { PromotionalCode.new }

  it 'reduces price if total is over 60 by 10%' do 
    subject.total_price_before_reduction = 100
    subject.total_price_after_percentage_reduction.must_equal 90
  end
  
  it 'reduces price if there are two or more items with reduced price' do
    item = Item.new(product_code: 0001, price: 10)
    subject.items = [item, item]
    subject.total_price_after_item_price_reduction.first.price.must_equal 8.50
    subject.total_price_after_item_price_reduction.last.price.must_equal 8.50
  end

end
