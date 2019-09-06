defmodule CryptoHustler.OrderPreparator do
  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Order, Ticker}

  @minimum_trade 0.00050000
  @selling_fee 0.0025

  # TODO try to buy even more coins using surplus left from dividing balance and preparing orders
  def prepare_buy_orders(market_summaries, available_base_currency_balance, number_of_coins) do
    number_of_coins = number_of_coins(available_base_currency_balance, number_of_coins)

    if number_of_coins > 0 do
      available_per_coin = available_base_currency_balance / number_of_coins

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

  def prepare_sell_orders(base_currency_code, profit_percentage, balances, orders, market_summaries, prepared_orders \\ [])
  def prepare_sell_orders(_, _, [], _, _, prepared_orders), do: prepared_orders
  def prepare_sell_orders(base_currency_code, profit_percentage, [head|tail], orders, market_summaries, prepared_orders) do
    %Balance{available: available, currency: %Currency{code: currency_code}} = head

    prepared_orders = if available > 0 && currency_code != base_currency_code do
      market_name = base_currency_code <> "-" <> currency_code

      if buy_order = find_buy_order(orders, market_name, head) do
        %Order{limit: rate} = buy_order
        percentage = profit_percentage * 0.01 + @selling_fee
        rate = Float.ceil(rate + rate * percentage, 8)

        if market_summary = find_market_summary(market_summaries, market_name) do
          %MarketSummary{ticker: %Ticker{last: current_rate}} = market_summary

          rate = if current_rate > rate do
            current_rate
          else
            rate
          end

          prepared_order = {%Market{name: market_name}, %Order{quantity: available, rate: rate}}
          [prepared_order|prepared_orders]
        else
          prepared_orders
        end
      else
        prepared_orders
      end
    else
      prepared_orders
    end

    prepare_sell_orders(base_currency_code, profit_percentage, tail, orders, market_summaries, prepared_orders)
  end

  defp number_of_coins(available_btc_balance, number_of_coins) do
    if available_btc_balance / number_of_coins >= @minimum_trade do
      number_of_coins
    else
      number_of_coins(available_btc_balance, number_of_coins - 1)
    end
  end

  defp prepare(market_summaries, number_of_coins, available_per_coin, prepared_orders \\ [])
  defp prepare([], _, _, prepared_orders), do: prepared_orders
  defp prepare([head|tail], number_of_coins, available_per_coin, prepared_orders) do
    %MarketSummary{market: market, ticker: %Ticker{bid: bid, last: last}} = head
    rate = if bid < last do
      Float.round(bid + 1.0e-8, 8)
    else
      last
    end
    rate_with_fee = rate + rate * 0.0025
    quantity = Float.floor(available_per_coin / rate_with_fee, 8)

    prepared_orders = if quantity >= market.minimum_trade do
      prepared_order = {market, %Order{quantity: quantity, rate: rate}}
      [prepared_order|prepared_orders]
    else
      prepared_orders
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

  defp find_buy_order([], _, _), do: nil
  defp find_buy_order([head|tail], market_name, %Balance{available: available} = balance) do
    case head do
      %Order{market: %Market{name: ^market_name}, order_type: "LIMIT_BUY", quantity: ^available} ->
        head
      _ ->
        find_buy_order(tail, market_name, balance)
    end
  end

  defp find_market_summary([], _), do: nil
  defp find_market_summary([head|tail], market_name) do
    case head do
      %MarketSummary{market: %Market{name: ^market_name}} ->
        head
      _ ->
        find_market_summary(tail, market_name)
    end
  end
end
