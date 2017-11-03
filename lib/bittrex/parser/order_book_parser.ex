defmodule Bittrex.Parser.OrderBookParser do
  alias Bittrex.Data.OrderBook
  alias Bittrex.Parser.OrderParser

  def call(item, "both") do
    %OrderBook{
      buy: Enum.map(item["buy"], &OrderParser.call/1),
      sell: Enum.map(item["sell"], &OrderParser.call/1),
    }
  end
  def call(item, type) do
    Map.put(%OrderBook{}, String.to_atom(type), Enum.map(item, &OrderParser.call/1))
  end
end
