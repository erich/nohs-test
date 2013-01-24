require_relative 'spec_helper'
require_relative '../lib/promotional_code'
require_relative '../lib/item'

describe PromotionalCode do
  
  subject { PromotionalCode.new }

  it 'has total_price' do
    subject.must_respond_to :total_price_before_reduction
  end

  it 'has percentage_reduction' do
    subject.must_respond_to :percentage_reduction
  end

  it 'reduces price if total is over 60 by 10%' do 
    subject.total_price_before_reduction = 70
    subject.total_price_after_percentage_reduction.must_equal 63
  end

  it 'doesn\'t reduce price if total is 60 or under 60' do
    subject.total_price_before_reduction = 60
    subject.total_price_after_percentage_reduction.must_equal 60
    subject.total_price_before_reduction = 59
    subject.total_price_after_percentage_reduction.must_equal 59
  end
  
  it 'changes price pro item' do
    item = Item.new(product_code: 0001, price: 10)
    subject.change_price_for_item(item).must_equal 8.50
  end

  it 'reduces price if there are two or more items with reduced price' do
    item = Item.new(product_code: 0001, price: 10)
    subject.items = [item, item]
    subject.total_price_after_item_price_reduction.first.price.must_equal 8.50
    subject.total_price_after_item_price_reduction.last.price.must_equal 8.50
  end

  it 'doesn\'t reduce price if there is only one item with reduced price' do
    item = Item.new(product_code: 0001, price: 10)
    subject.items = [item]
    subject.total_price_after_item_price_reduction.first.price.must_equal 10
  end

end
