require 'bigdecimal'

class HomeSaleProfitCalculator
  attr_reader :realtor_fee_percentage, :mortgage_balance, :sale_price

  def initialize(realtor_fee_percentage: 0.06, mortgage_balance:, sale_price:)
    @mortgage_balance = mortgage_balance.to_i
    @realtor_fee_percentage = BigDecimal(realtor_fee_percentage.to_s)
    @sale_price = sale_price.to_i
  end

  def profit
    sale_price - realtor_fee - estimated_other_fees - mortgage_balance
  end

  def profit_formated
    profit.to_s('+F').reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def estimated_other_fees
    BigDecimal("0.04") * sale_price
  end

  def realtor_fee
    realtor_fee_percentage * sale_price
  end
end

calculator = HomeSaleProfitCalculator.new(sale_price: ARGV[0], mortgage_balance: ARGV[1])

puts calculator.profit_formated
