defmodule CryptoHustler.CoinFilter do
  alias Bittrex.Data.{Currency, Market, Order}

  def find_new_currencies(orders, currencies, new_currencies \\ [])
  def find_new_currencies(_, [], new_currencies), do: new_currencies
  def find_new_currencies(orders, [head|tail], new_currencies) do
    if valid_currency(head) && !has_been_traded(head.code, orders) do
      new_currencies = [head|new_currencies]
    end

    find_new_currencies(orders, tail, new_currencies)
  end

  defp valid_currency(%Currency{active: false}), do: false
  defp valid_currency(%Currency{code: "BTC"}), do: false
  defp valid_currency(_), do: true

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
