defmodule CryptoHustler.MarketFilter do
  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Ticker}

  def filter(market_summaries, balances, new_coins \\ [])
  def filter([], _, new_coins), do: new_coins
  def filter([head|tail], balances, new_coins) do
    %MarketSummary{market: market} = head
    %Market{market_currency: market_currency} = market

    if is_active(market) && is_btc_market(market) && !is_in_posession(market_currency, balances) && has_potential(head) do
      filter(tail, balances, [head|new_coins])
    else
      filter(tail, balances, new_coins)
    end
  end

  defp is_active(%Market{base_currency: %Currency{active: false}}), do: false
  defp is_active(%Market{market_currency: %Currency{active: false}}), do: false
  defp is_active(_), do: true

  defp is_btc_market(%Market{base_currency: %Currency{code: "BTC"}}), do: true
  defp is_btc_market(_), do: false

  defp is_in_posession(_, []), do: false
  defp is_in_posession(%Currency{code: currency_code} = currency, [head|tail]) do
    case head do
      %Balance{currency: %Currency{code: ^currency_code}, balance: balance} ->
        balance > 0
      _ ->
        is_in_posession(currency, tail)
    end
  end

  defp has_potential(%MarketSummary{high: high, low: low, ticker: %Ticker{last: last}}) do
    high_diff = (high - last) / last
    low_diff = (low - last) / last
    high_diff >= 0.03 && low_diff <= -0.01
  end
end
