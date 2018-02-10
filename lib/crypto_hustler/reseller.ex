defmodule CryptoHustler.Reseller do
  alias Bittrex.Data.{Balance, Currency, Market}
  alias Bittrex.Service.Account.{GetBalances, GetOrderHistory}
  alias Bittrex.Service.Market.{Cancel, GetOpenOrders, SellLimit}
  alias Bittrex.Service.Public.{GetCurrencies, GetMarkets, GetMarketSummaries}
  alias CryptoHustler.{DataCombiner, OrderPreparator}

  def do_your_thing(profit_percentage, base_currency_code \\ "BTC") do
    {:ok, currencies} = GetCurrencies.call()
    {:ok, markets} = GetMarkets.call()
    {:ok, market_summaries} = GetMarketSummaries.call()
    {:ok, balances} = GetBalances.call()

    market_summaries = currencies
    |> DataCombiner.combine_currencies_with_markets(markets)
    |> DataCombiner.combine_markets_with_market_summaries(market_summaries)

    orders = balances
    |> Enum.filter(fn(x) -> x.available > 0 && x.currency.code != "BTC" end)
    |> get_order_history(base_currency_code)
    |> get_newest_orders()

    OrderPreparator.prepare_sell_orders(base_currency_code, profit_percentage, balances, orders, market_summaries)
    |> Enum.each(&sell/1)
  end

  def cancel_sell_orders do
    {:ok, open_orders} = GetOpenOrders.call()

    Enum.filter(open_orders, fn(x) -> x.order_type == "LIMIT_SELL" end)
    |> Enum.each(&Cancel.call/1)
  end

  defp get_order_history(balances, base_currency_code, orders \\ [])
  defp get_order_history([], _, orders), do: orders
  defp get_order_history([head|tail], base_currency_code, orders) do
    %Balance{currency: %Currency{code: currency_code}} = head
    market = %Market{name: base_currency_code <> "-" <> currency_code}

    case GetOrderHistory.call(market) do
      {:ok, history} ->
        get_order_history(tail, base_currency_code, orders ++ history)
      {:error, _} ->
        get_order_history(tail, base_currency_code, orders)
    end
  end

  defp get_newest_orders(orders) do
    {:ok, new_orders} = GetOrderHistory.call()
    orders ++ new_orders
  end

  defp sell({market, order}) do
    SellLimit.call(market, order)
  end
end
