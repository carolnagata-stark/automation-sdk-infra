#!/usr/bin/env ruby
# Get your Stark Infra issuing balance.
#
# This is how you use the Starkinfra SDK in a real project.

require 'starkinfra'

# Configure your project credentials
project = StarkInfra::Project.new(
  environment: 'sandbox',
  id: ENV['SANDBOX_INFRA_ID'],
  private_key: ENV['SANDBOX_INFRA_PRIVATE_KEY']
)

# Fetch your issuing balance
balance = StarkInfra::IssuingBalance.get(user: project)

puts "Balance: #{balance.amount} #{balance.currency}"
puts "ID: #{balance.id}"
puts "Updated: #{balance.updated}"
