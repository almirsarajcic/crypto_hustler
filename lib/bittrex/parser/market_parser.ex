defmodule Bittrex.Parser.MarketParser do
  alias Bittrex.Data.Market
  alias Bittrex.Parser.CurrencyParser

  def call(item) do
    %Market{
      name: item["MarketName"] || item["Exchange"],
      minimum_trade: item["MinTradeSize"],
      active: item["IsActive"],
      created_at: Bittrex.parse_datetime(item["Created"]),
      base_currency: CurrencyParser.call(item, "Base"),
      market_currency: CurrencyParser.call(item, "Market"),
    }
  end
end
