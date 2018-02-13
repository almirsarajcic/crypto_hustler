defmodule CryptoHustler.Reseller do
  alias Bittrex.Service.Account.GetBalances
  alias Bittrex.Service.Market.{Cancel, GetOpenOrders, SellLimit}
  alias Bittrex.Service.Public.{GetCurrencies, GetMarkets, GetMarketSummaries}
  alias CryptoHustler.{DataCombiner, OrderPreparator, OrdersCsvParser}

  def do_your_thing(profit_percentage, base_currency_code \\ "BTC") do
    {:ok, currencies} = GetCurrencies.call()
    {:ok, markets} = GetMarkets.call()
    {:ok, market_summaries} = GetMarketSummaries.call()
    {:ok, balances} = GetBalances.call()

    market_summaries = currencies
    |> DataCombiner.combine_currencies_with_markets(markets)
    |> DataCombiner.combine_markets_with_market_summaries(market_summaries)

    # Make sure to upload .csv file to Google Docs and export it from there.
    # There are some encoding issues otherwise.
    file_stream = "../../fullOrders.csv"
    |> Path.expand(__DIR__)
    |> File.stream!()
    orders = OrdersCsvParser.call(file_stream)

    OrderPreparator.prepare_sell_orders(base_currency_code, profit_percentage, balances, orders, market_summaries)
    |> Enum.each(&sell/1)
  end

  def cancel_sell_orders do
    {:ok, open_orders} = GetOpenOrders.call()

    Enum.filter(open_orders, fn(x) -> x.order_type == "LIMIT_SELL" end)
    |> Enum.each(&Cancel.call/1)
  end

  defp sell({market, order}) do
    SellLimit.call(market, order)
  end
end
