require 'minitest/spec'
require 'minitest/autorun'

class Checkout
  def initialize(promotional_code)
  end
  def scan(item)
  end
  def total
  end
end

class PromotionalCode
end

class Item
  def initialize(hash_values)
  end
  def price
  end
end

describe Checkout do
  subject { Checkout.new(PromotionalCode.new)}

  let(:lavender_heart) { Item.new(product_code: 001, name: 'Lavender heart', price: 9.25) }
  let(:personalized_cufflinks) { Item.new(product_code: 002, name: 'Personalised cufflinks', price: 45.00) }
  let(:kids_t_shirt) { Item.new(product_code: 003, name: 'Kids T-shirt', price: 19.95) }

  it 'has checkout method' do
    subject.respond_to?(:checkout).must_equal true
  end 

  it 'has total method' do
    lavender_heart.price.must_equal true
    subject.respond_to?(:total).must_equal true
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
