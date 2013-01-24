require_relative 'spec_helper'
require_relative '../lib/percentage_price_reduction'


describe PercentagePriceReduction do 

  subject { PercentagePriceReduction.new(70) }

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

  describe 'change of by how many percents and total over price' do
    subject { PercentagePriceReduction.new(100, by_how_many_percents: 50, total_price_over: 90) }

    it 'reduces prices by 50%' do
      subject.total_price_after_percentage_reduction.must_equal 50
    end

    it 'doesn\'t reduce price if is not over 90' do
      subject.total_price_before_reduction = 89
      subject.total_price_after_percentage_reduction.must_equal 89
    end
  end
end
