defmodule IssuingBalanceExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :issuing_balance_example,
      version: "1.0.0",
      elixir: "~> 1.9",
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:inets]
    ]
  end

  defp deps do
    [
      {:starkinfra, "~> 0.1.0"}
    ]
  end
end
