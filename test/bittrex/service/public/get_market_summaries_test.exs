defmodule Bittrex.Service.Public.GetMarketSummariesTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, MarketSummary, Ticker}
  alias Bittrex.Service.Public.GetMarketSummaries

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns list of Bittrex.MarketSummary structs" do
    InMemoryClient.push({:ok, [%{
      "MarketName" => "BTC-888",
      "High" => 0.00000919,
      "Low" => 0.00000820,
      "Volume" => 74339.61396015,
      "Last" => 0.00000820,
      "BaseVolume" => 0.64966963,
      "TimeStamp" => "2014-07-09T07:19:30.15",
      "Bid" => 0.00000820,
      "Ask" => 0.00000831,
      "OpenBuyOrders" => 15,
      "OpenSellOrders" => 15,
      "PrevDay" => 0.00000821,
      "Created" => "2014-03-20T06:00:00",
      "DisplayMarketName" => nil
    }, %{
      "MarketName" => "BTC-A3C",
      "High" => 0.00000072,
      "Low" => 0.00000001,
      "Volume" => 166340678.42280999,
      "Last" => 0.00000005,
      "BaseVolume" => 17.59720424,
      "TimeStamp" => "2014-07-09T07:21:40.51",
      "Bid" => 0.00000004,
      "Ask" => 0.00000005,
      "OpenBuyOrders" => 18,
      "OpenSellOrders" => 18,
      "PrevDay" => 0.00000002,
      "Created" => "2014-05-30T07:57:49.637",
      "DisplayMarketName" => nil
    }]})

    assert {:ok, [%MarketSummary{
      market: %Market{
        name: "BTC-888",
        created_at: ~N[2014-03-20 06:00:00],
      },
      ticker: %Ticker{
        bid: 0.00000820,
        ask: 0.00000831,
        last: 0.00000820,
      },
      high: 0.00000919,
      low: 0.00000820,
      previous_day: 0.00000821,
      volume: 74339.61396015,
      base_volume: 0.64966963,
      open_buy_orders: 15,
      open_sell_orders: 15,
    }, %MarketSummary{
      market: %Market{
        name: "BTC-A3C",
        created_at: ~N[2014-05-30 07:57:49.637],
      },
      ticker: %Ticker{
        bid: 0.00000004,
        ask: 0.00000005,
        last: 0.00000005,
      },
      high: 0.00000072,
      low: 0.00000001,
      previous_day: 0.00000002,
      volume: 166340678.42280999,
      base_volume: 17.59720424,
      open_buy_orders: 18,
      open_sell_orders: 18,
    }]} = GetMarketSummaries.call()
  end
end
