defmodule Bittrex.Parser.TickerParser do
  alias Bittrex.Data.Ticker

  def call(item) do
    %Ticker{
      bid: item["Bid"],
      ask: item["Ask"],
      last: item["Last"],
    }
  end
end
