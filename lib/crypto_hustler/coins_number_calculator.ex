defmodule CryptoHustler.CoinsNumberCalculator do
  alias Bittrex.Data.Balance

  def calculate(balances, max_number) do
    max_number - count_coins(balances)
  end

  defp count_coins(balances, count \\ 0)
  defp count_coins([], count), do: count
  defp count_coins([%Balance{balance: balance}|tail], count) when balance > 0, do: count_coins(tail, count + 1)
  defp count_coins([_|tail], count), do: count_coins(tail, count)
end
