defmodule CryptoHustler.OrderPreparator do
  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Order, Ticker}

  @minimum_trade 0.00050000
  @number_of_coins 5

  # TODO try to buy even more coins using surplus left from dividing balance and preparing orders
  def prepare_buy_orders(market_summaries, available_btc_balance) do
    number_of_coins = number_of_coins(available_btc_balance)

    if number_of_coins > 0 do
      available_per_coin = available_btc_balance / number_of_coins

      prepare(market_summaries, number_of_coins, available_per_coin)
    end
  end

  def prepare_stale_buy_orders(open_orders, datetime \\ NaiveDateTime.utc_now(), orders_to_cancel \\ [])
  def prepare_stale_buy_orders([], _, orders_to_cancel), do: orders_to_cancel
  def prepare_stale_buy_orders([head|tail], datetime, orders_to_cancel) do
    %Order{cancel_initiated: cancel_initiated, opened_at: opened_at, order_type: order_type} = head

    if !cancel_initiated && order_type == "LIMIT_BUY" && is_stale(opened_at, datetime) do
      prepare_stale_buy_orders(tail, datetime, [head|orders_to_cancel])
    else
      prepare_stale_buy_orders(tail, datetime, orders_to_cancel)
    end
  end

  def prepare_sell_orders(balances, orders, market_summaries, prepared_orders \\ [])
  def prepare_sell_orders([], orders, market_summaries, prepared_orders), do: prepared_orders
  def prepare_sell_orders([head|tail], orders, market_summaries, prepared_orders) do
    %Balance{available: available, currency: %Currency{code: currency_code}} = head

    if available > 0 && currency_code != "BTC" do
      if buy_order = find_buy_order(orders, head) do
        %Order{price_per_unit: rate} = buy_order
        rate = Float.ceil(rate + rate * 0.01, 8)

        if market_summary = find_market_summary(market_summaries, currency_code) do
          %MarketSummary{ticker: %Ticker{last: current_rate}} = market_summary

          if current_rate > rate do
            rate = current_rate
          end

          prepared_order = {%Market{name: "BTC-" <> currency_code}, %Order{quantity: available, rate: rate}}
          prepared_orders = [prepared_order|prepared_orders]
        end
      end
    end

    prepare_sell_orders(tail, orders, market_summaries, prepared_orders)
  end

  defp number_of_coins(available_btc_balance, number_of_coins \\ @number_of_coins) do
    if available_btc_balance / number_of_coins >= @minimum_trade do
      number_of_coins
    else
      number_of_coins(available_btc_balance, number_of_coins - 1)
    end
  end

  defp prepare(market_summaries, number_of_coins, available_per_coin, prepared_orders \\ [])
  defp prepare([], number_of_coins, available_per_coin, prepared_orders), do: prepared_orders
  defp prepare([head|tail], number_of_coins, available_per_coin, prepared_orders) do
    %MarketSummary{market: market, ticker: %Ticker{last: rate}} = head
    quantity = Float.floor(available_per_coin / rate, 8)

    if quantity >= market.minimum_trade do
      prepared_order = {market, %Order{quantity: quantity, rate: rate}}
      prepared_orders = [prepared_order|prepared_orders]
    end

    if length(prepared_orders) >= number_of_coins do
      prepared_orders
    else
      prepare(tail, number_of_coins, available_per_coin, prepared_orders)
    end
  end

  defp is_stale(opened_at, datetime) do
    Timex.before?(opened_at, Timex.shift(datetime, minutes: -5))
  end

  defp find_buy_order([], _), do: nil
  defp find_buy_order([head|tail], %Balance{available: available, currency: %Currency{code: currency_code}} = balance) do
    case head do
      %Order{market: %Market{name: "BTC-" <> ^currency_code}, order_type: "LIMIT_BUY", quantity: ^available} ->
        head
      _ ->
        find_buy_order(tail, balance)
    end
  end

  defp find_market_summary([], _), do: nil
  defp find_market_summary([head|tail], currency_code) do
    case head do
      %MarketSummary{market: %Market{market_currency: %Currency{code: ^currency_code}}} ->
        head
      _ ->
        find_market_summary(tail, currency_code)
    end
  end
end
