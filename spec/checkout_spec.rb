require_relative 'spec_helper'
require_relative '../lib/checkout'

describe Checkout do

  subject { Checkout.new(PromotionalCode.new)}

  let(:lavender_heart) { Item.new(product_code: 001, name: 'Lavender heart', price: 9.25) }

  it 'has total method' do
    subject.must_respond_to :total
  end 

  it 'scans item' do
    subject.must_respond_to :scan
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
end
