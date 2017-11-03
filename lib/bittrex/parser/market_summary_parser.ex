defmodule Bittrex.Parser.MarketSummaryParser do
  alias Bittrex.Data.MarketSummary
  alias Bittrex.Parser.{MarketParser, TickerParser}

  def call(item) do
    %MarketSummary{
      market: MarketParser.call(item),
      ticker: TickerParser.call(item),
      high: item["High"],
      low: item["Low"],
      previous_day: item["PrevDay"],
      volume: item["Volume"],
      base_volume: item["BaseVolume"],
      open_buy_orders: item["OpenBuyOrders"],
      open_sell_orders: item["OpenSellOrders"],
    }
  end
end
