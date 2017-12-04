defmodule CryptoHustler.BalanceCalculator do
  alias Bittrex.Data.{Currency, Market, MarketSummary, Ticker}
  alias Bittrex.Service.Account.GetBalances
  alias Bittrex.Service.Public.GetMarketSummaries

  def get_estimated_btc_balance do
    {:ok, balances} = GetBalances.call()
    {:ok, market_summaries} = GetMarketSummaries.call()

    Float.round(calculate_btc_balance(market_summaries, balances), 8)
  end

  defp calculate_btc_balance(_, _, balance \\ 0.0)
  defp calculate_btc_balance(_, [], balance), do: balance
  defp calculate_btc_balance(market_summaries, [head|tail], balance) do
    balance = case head.currency do
      %Currency{code: "BTC"} ->
        balance + head.balance
      %Currency{code: code} ->
        market_name = "BTC-" <> code
        price = get_currency_price(market_name, market_summaries)
        balance + head.balance * price
    end

    calculate_btc_balance(market_summaries, tail, balance)
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
