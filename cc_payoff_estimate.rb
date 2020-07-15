#!/usr/bin/env ruby

##
# Calculate the interest paid and number of payments needed to pay off a credit card.
#
# Ex.
# cc_payment_estimator.rb 10_000 12.99 500.0
#

class String
  def bold
    "\e[1m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def red_bg
    "\e[41m#{self}\e[0m"
  end
end

class CCPayoffEstimator
  attr_reader :apr, :starting_balance, :monthly_payment

  def initialize(starting_balance, apr, monthly_payment)
    @apr = apr.to_f
    @starting_balance = starting_balance.to_f
    @monthly_payment = monthly_payment.to_f
  end

  def print_estimate
    current_balance = starting_balance
    payments = 0
    total_interest_paid = 0

    puts "Starting balance: #{to_usd current_balance}",
         "APR: #{apr}%",
         "Monthly payment: #{to_usd monthly_payment}"


    while current_balance > 0 do
      interest = current_balance * apr/100/12
      if interest >= monthly_payment
        puts "\nThe #{to_usd(interest).bold} interest for the next billing cycle is " \
             "greater than or equal to the #{to_usd(monthly_payment).red_bg} monthly payment.",
             "At this rate, it will never be paid off! 😵".red
        exit 1
      end
      current_balance -= (monthly_payment - interest)
      total_interest_paid += interest
      payments += 1
    end

    puts "\nOnce this is paid off...",
         "Interest paid: #{to_usd(total_interest_paid).bold}",
         "Payments made: #{payments.to_s.bold}"
  end

  private

  ##
  # Return a US dollar-formatted string for +num+
  #
  def to_usd(num)
    '$' + sprintf('%.2f',num)
      .reverse
      .scan(/(\d*\.\d{1,3}|\d{1,3})/)
      .join(',')
      .reverse
  end
end

##
# Check runtime arguments
#
unless ARGV.length == 3
  puts "Please provide the current balance, APR, and monthly payment".red,
       '  Ex.',
       "#{__FILE__} 10_000.03 12.99 500"
  exit 1
end

CCPayoffEstimator.new(*ARGV).print_estimate
