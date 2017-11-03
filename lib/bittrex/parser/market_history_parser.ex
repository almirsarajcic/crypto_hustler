defmodule Bittrex.Parser.MarketHistoryParser do
  alias Bittrex.Data.MarketHistory

  def call(item) do
    %MarketHistory{
      id: item["Id"],
      created_at: Bittrex.parse_datetime(item["TimeStamp"]),
      quantity: item["Quantity"],
      price: item["Price"],
      total: item["Total"],
      fill_type: item["FillType"],
      order_type: item["OrderType"],
    }
  end
end
