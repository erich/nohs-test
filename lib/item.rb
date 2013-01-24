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
