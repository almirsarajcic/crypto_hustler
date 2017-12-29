defmodule CryptoHustler.Bot do
  use Task, restart: :permanent

  alias Bittrex.Service.Account.{GetBalances, GetOrderHistory}
  alias Bittrex.Service.Market.{BuyLimit, Cancel, GetOpenOrders, SellLimit}
  alias Bittrex.Service.Public.{GetCurrencies, GetMarkets, GetMarketSummaries}
  alias CryptoHustler.{BaseCurrencyBalanceCalculator, DataCombiner, MarketFilter, OrderPreparator}

  require Logger

  @minimum_trade 0.00050000

  def start_link() do
    Task.start_link(__MODULE__, :hustle, [])
  end

  def hustle do
    sleep(5)

    {:ok, open_orders} = GetOpenOrders.call()
    {:ok, currencies} = GetCurrencies.call()
    {:ok, markets} = GetMarkets.call()
    {:ok, market_summaries} = GetMarketSummaries.call()
    {:ok, balances} = GetBalances.call()

    market_summaries = currencies
    |> DataCombiner.combine_currencies_with_markets(markets)
    |> DataCombiner.combine_markets_with_market_summaries(market_summaries)

    config = Application.get_env(:crypto_hustler, :bittrex)
    base_currency_code = config[:base_currency]
    number_of_coins = String.to_integer(config[:number_of_coins])

    {:ok, orders} = GetOrderHistory.call()
    OrderPreparator.prepare_sell_orders(base_currency_code, balances, orders, market_summaries)
    |> Enum.each(&sell/1)

    OrderPreparator.prepare_stale_buy_orders(open_orders)
    |> Enum.each(&Cancel.call/1)

    base_currency_balance = BaseCurrencyBalanceCalculator.calculate(base_currency_code, balances, market_summaries)

    if base_currency_balance.available >= @minimum_trade do
      market_summaries
      |> MarketFilter.filter(base_currency_code, balances, open_orders)
      |> Enum.shuffle()
      |> OrderPreparator.prepare_buy_orders(base_currency_balance.available, number_of_coins)
      |> Enum.each(&buy/1)
    end
  end

  defp buy({market, order}) do
    BuyLimit.call(market, order)
    Logger.info "Buying: " <> market.name
  end

  defp sell({market, order}) do
    SellLimit.call(market, order)
    Logger.info "Selling: " <> market.name
  end

  defp sleep(seconds) do
    :timer.sleep(:timer.seconds(seconds))
  end
end
