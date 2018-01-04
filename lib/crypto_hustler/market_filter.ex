defmodule CryptoHustler.MarketFilter do
  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Order, Ticker}

  def filter(market_summaries, base_currency_code, balances, open_orders, new_coins \\ [])
  def filter([], _, _, _, new_coins), do: new_coins
  def filter([head|tail], base_currency_code, balances, open_orders, new_coins) do
    %MarketSummary{market: market} = head
    %Market{market_currency: market_currency} = market

    if is_active(market) && is_base_currency_market(base_currency_code, market) && !is_in_posession(market_currency, balances) && !buying(market_currency, open_orders) && has_potential(head) do
      filter(tail, base_currency_code, balances, open_orders, [head|new_coins])
    else
      filter(tail, base_currency_code, balances, open_orders, new_coins)
    end
  end

  defp is_active(%Market{active: false}), do: false
  defp is_active(%Market{base_currency: %Currency{active: false}}), do: false
  defp is_active(%Market{market_currency: %Currency{active: false}}), do: false
  defp is_active(_), do: true

  defp is_base_currency_market(base_currency_code, %Market{base_currency: %Currency{code: currency_code}}) do
    base_currency_code == currency_code
  end

  defp is_in_posession(_, []), do: false
  defp is_in_posession(%Currency{code: currency_code} = currency, [head|tail]) do
    case head do
      %Balance{currency: %Currency{code: ^currency_code}, balance: balance} ->
        balance > 0
      _ ->
        is_in_posession(currency, tail)
    end
  end

  defp buying(_, []), do: false
  defp buying(%Currency{code: code} = market_currency, [head|tail]) do
    case head do
      %Order{market: %Market{name: market_name}, order_type: "LIMIT_BUY"} ->
        if market_name =~ "-" <> code do
          true
        else
          buying(market_currency, tail)
        end
      _ ->
        buying(market_currency, tail)
    end
  end

  defp has_potential(%MarketSummary{base_volume: base_volume, high: high, low: low, ticker: %Ticker{last: last}}) do
    high_diff = (high - last) / last
    low_diff = (low - last) / last
    high_diff >= 0.03 && low_diff <= -0.01 && base_volume > 10
  end
end
