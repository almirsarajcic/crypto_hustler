defmodule Bittrex.Service.Public.GetTickerTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Ticker}
  alias Bittrex.Service.Public.GetTicker

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns Bittrex.Ticker" do
    InMemoryClient.push({:ok, %{
      "Bid" => 2.05670368,
      "Ask" => 3.35579531,
      "Last" => 3.35579531
    }})

    assert {:ok, %Ticker{
      bid: 2.05670368,
      ask: 3.35579531,
      last: 3.35579531,
    }} = GetTicker.call(%Market{name: "BTC-LTC"})
  end
end
