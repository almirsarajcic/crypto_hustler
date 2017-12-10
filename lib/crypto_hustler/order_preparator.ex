defmodule CryptoHustler.OrderPreparator do
  alias Bittrex.Data.{Currency, MarketSummary, Order, Ticker}

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
end
