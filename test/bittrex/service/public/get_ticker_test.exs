defmodule Bittrex.Service.Public.GetTickerTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Ticker, Request, Response}
  alias Bittrex.Service.Public.GetTicker

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /public/getticker and returns Bittrex.Ticker" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "Bid" => 2.05670368,
      "Ask" => 3.35579531,
      "Last" => 3.35579531
    }})

    assert {:ok, %Ticker{
      bid: 2.05670368,
      ask: 3.35579531,
      last: 3.35579531,
    }} = GetTicker.call(%Market{name: "BTC-LTC"})

    assert %Request{endpoint: "/public/getticker", params: params} = InMemoryClient.pop()
    assert params == %{market: "BTC-LTC"}
  end
end
