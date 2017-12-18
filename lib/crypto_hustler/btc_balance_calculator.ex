defmodule CryptoHustler.BtcBalanceCalculator do
  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Ticker}
  alias CryptoHustler.BtcBalance

  def calculate(balances, market_summaries) do
    btc_balance = get_btc_balance(balances)
    estimated = estimated_btc_balance(market_summaries, balances)

    %BtcBalance{
      real: btc_balance.balance,
      estimated: Float.round(estimated, 8),
      available: btc_balance.available,
    }
  end

  defp get_btc_balance([head|tail]) do
    case head do
      %Balance{currency: %Currency{code: "BTC"}} ->
        head
      _ ->
        get_btc_balance(tail)
    end
  end

  defp estimated_btc_balance(_, _, balance \\ 0.0)
  defp estimated_btc_balance(_, [], balance), do: balance
  defp estimated_btc_balance(market_summaries, [head|tail], balance) do
    balance = case head.currency do
      %Currency{code: "BTC"} ->
        balance + head.balance
      %Currency{code: code} ->
        market_name = "BTC-" <> code
        price = get_currency_price(market_name, market_summaries)
        balance + head.balance * price
    end

    estimated_btc_balance(market_summaries, tail, balance)
  end

  defp get_currency_price(market_name, [head|tail]) do
    case head do
      %MarketSummary{market: %Market{name: ^market_name}, ticker: %Ticker{last: price}} ->
        price
      _ ->
        get_currency_price(market_name, tail)
    end
  end
end
