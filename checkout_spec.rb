require 'minitest/spec'
require 'minitest/autorun'

class PromotionalCode
end

class Item

  attr_reader :product_code, :name, :price

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
    "£#{calculate_total_price}"
  end

  def calculate_total_price
    scanned_items.collect(&:price).inject(:+)
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
