defmodule CryptoHustler.Bot do
  alias Bittrex.Service.Account.GetBalances
  alias Bittrex.Service.Market.{BuyLimit, Cancel, GetOpenOrders}
  alias Bittrex.Service.Public.{GetCurrencies, GetMarkets, GetMarketSummaries}
  alias CryptoHustler.{BtcBalanceCalculator, DataCombiner, MarketFilter, OrderPreparator}

  @minimum_trade 0.00050000

  def hustle do
    {:ok, open_orders} = GetOpenOrders.call()
    OrderPreparator.prepare_stale_buy_orders(open_orders)
    |> Enum.each(&Cancel.call/1)

    {:ok, balances} = GetBalances.call()
    {:ok, market_summaries} = GetMarketSummaries.call()

    btc_balance = BtcBalanceCalculator.calculate(balances, market_summaries)

    if btc_balance.available >= @minimum_trade do
      {:ok, currencies} = GetCurrencies.call()
      {:ok, markets} = GetMarkets.call()

      currencies
      |> DataCombiner.combine_currencies_with_markets(markets)
      |> DataCombiner.combine_markets_with_market_summaries(market_summaries)
      |> MarketFilter.filter(balances)
      |> Enum.shuffle()
      |> OrderPreparator.prepare_buy_orders(btc_balance.available)
      |> Enum.each(&buy/1)
    end
  end

  defp buy({market, order}), do: BuyLimit.call(market, order)
end
