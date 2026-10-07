#!/usr/bin/env elixir
# Get your Stark Infra issuing balance.
#
# This is how you use the Starkinfra SDK in a real project.

Mix.install([{:starkinfra, "~> 0.1.0"}])

# Configure your project credentials
project = StarkInfra.project(
  environment: :sandbox,
  id: System.fetch_env!("SANDBOX_INFRA_ID"),
  private_key: System.fetch_env!("SANDBOX_INFRA_PRIVATE_KEY")
)

# Fetch your issuing balance
{:ok, balance} = StarkInfra.IssuingBalance.get(user: project)

IO.inspect(balance)
IO.puts("Balance: #{balance.amount} #{balance.currency}")
IO.puts("ID: #{balance.id}")
IO.puts("Updated: #{balance.updated}")
