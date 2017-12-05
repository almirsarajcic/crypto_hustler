defmodule CryptoHustler.CoinFinder do
  alias Bittrex.Data.{Market, Order}

  def find_new_currencies(orders, currencies, new_currencies \\ [])
  def find_new_currencies(_, [], new_currencies), do: new_currencies
  def find_new_currencies(orders, [head|tail], new_currencies) do
    unless head.code == "BTC" || has_been_traded(head.code, orders) do
      new_currencies = [head|new_currencies]
    end

    find_new_currencies(orders, tail, new_currencies)
  end

  defp has_been_traded(_, []), do: false
  defp has_been_traded(currency_code, [head|tail]) do
    case head do
      %Order{market: %Market{name: "BTC-" <> ^currency_code}} ->
        true
      _ ->
        has_been_traded(currency_code, tail)
    end
  end
end
