require 'minitest/spec'
require 'minitest/autorun'

class PromotionalCode
  attr_accessor :total_amount_before_reduction, :items

  def over_amount
    60
  end

  def percentage_reduction(by_how_many_percents = 10)
    total_amount_before_reduction - ((total_amount_before_reduction.to_f / 100) * by_how_many_percents)
  end

  def total_price_after_percentage_reduction 
    return total_amount_before_reduction if total_amount_before_reduction <= over_amount
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
    item
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

describe PromotionalCode do
  
  subject { PromotionalCode.new }

  it 'has total_amount' do
    subject.respond_to?(:total_amount_before_reduction).must_equal true
  end

  it 'has percentage_reduction' do
    subject.respond_to?(:percentage_reduction).must_equal true
  end

  it 'reduces price if total is over 60 by 10%' do 
    subject.total_amount_before_reduction = 70
    subject.total_price_after_percentage_reduction.must_equal 63
  end

  it 'doesn\'t reduce price if total is 60 or under 60' do
    subject.total_amount_before_reduction = 60
    subject.total_price_after_percentage_reduction.must_equal 60
    subject.total_amount_before_reduction = 59
    subject.total_price_after_percentage_reduction.must_equal 59
  end
  
  it 'changes price pro item' do
    item = Item.new(product_code: 0001, price: 10)
    subject.change_price_for_item(item).price.must_equal 8.50
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

class Item

  attr_reader :product_code, :name
  attr_accessor :price

  def initialize(hash_values)
    @product_code = hash_values[:product_code]
    @name = hash_values[:name]
    @price = hash_values[:price]
  end

  def price
    Float(@price)
  end
end

describe Item do 

  subject { Item.new(product_code: 000, name: 'General item', price: 1.00) }

  it 'has price and it is float' do
    subject.price.must_equal 1.00
    subject.price.is_a?(Float).must_equal true
  end

  it 'has product code' do
    subject.product_code.must_equal 000
  end

  it 'has name' do
    subject.name.must_equal 'General item'
  end

end

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
    promotional_code.total_amount_before_reduction = scanned_items.collect(&:price).inject(:+)
    promotional_code.total_price_after_percentage_reduction
  end

  def round_calculated_total_price
    calculate_total_price.round(2)
  end
  
end

describe Checkout do

  subject { Checkout.new(PromotionalCode.new)}

  let(:lavender_heart) { Item.new(product_code: 001, name: 'Lavender heart', price: 9.25) }
  let(:personalized_cufflinks) { Item.new(product_code: 002, name: 'Personalised cufflinks', price: 45.00) }
  let(:kids_t_shirt) { Item.new(product_code: 003, name: 'Kids T-shirt', price: 19.95) }

  it 'has total method' do
    subject.respond_to?(:total).must_equal true
  end 

  it 'scans item' do
    subject.respond_to?(:scan).must_equal true
  end
  
  describe 'with one time scanned' do

    before(:each) do 
      subject.scan(lavender_heart)
    end

    it 'has one scanned item' do 
      subject.scanned_items.size.must_equal 1
      subject.scanned_items.first.must_equal lavender_heart
    end

    it 'calculates total price' do
      subject.total.must_equal '£9.25'
    end

  end

  describe 'acceptance tests' do 
    it 'calculates simple checkout' do
      co = subject
      co.scan(lavender_heart)
      co.scan(personalized_cufflinks)
      co.scan(kids_t_shirt)
      co.total.must_equal '£66.78'
    end

    it 'calculates two hears and t-shirt checkout' do
      co = subject
      co.scan(lavender_heart)
      co.scan(kids_t_shirt)
      co.scan(lavender_heart)
      co.total.must_equal '£36.95'
    end

    it 'calculates two hears, personalized_cufflinks and t-shirt checkout' do
      co = subject
      co.scan(lavender_heart)
      co.scan(personalized_cufflinks)
      co.scan(lavender_heart)
      co.scan(kids_t_shirt)
      co.total.must_equal '£73.76'
    end
  end
end
