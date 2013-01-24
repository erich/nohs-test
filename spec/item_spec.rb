require_relative 'spec_helper'
require_relative '../lib/item'

describe Item do 

  subject { Item.new(product_code: 000, name: 'General item', price: 1.00) }

  it 'has price and it is float' do
    subject.price.must_equal 1.00
    subject.price.must_be_kind_of Float
  end

  it 'has product code' do
    subject.product_code.must_equal 000
  end

  it 'has name' do
    subject.name.must_equal 'General item'
  end

end
