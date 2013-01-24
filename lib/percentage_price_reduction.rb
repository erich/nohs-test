class PercentagePriceReduction

  attr_accessor :total_price_before_reduction
  attr_reader :by_how_many_percents, :total_price_over

  def initialize(total_price_before_reduction, by_how_many_percents: 10,
                 total_price_over: 60)
    @total_price_before_reduction = total_price_before_reduction
    @by_how_many_percents = by_how_many_percents
    @total_price_over = total_price_over
  end

  def total_price_after_percentage_reduction 
    return total_price_before_reduction if total_price_before_reduction <= total_price_over
    percentage_reduction
  end

  def percentage_reduction
    total_price_before_reduction - ((total_price_before_reduction.to_f / 100) * by_how_many_percents)
  end
end
