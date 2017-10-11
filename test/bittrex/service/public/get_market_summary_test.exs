defmodule Bittrex.Service.Public.GetMarketSummaryTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, MarketSummary, Ticker}
  alias Bittrex.Service.Public.GetMarketSummary

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns Bittrex.MarketSummary struct" do
    InMemoryClient.push({:ok, %{
      "MarketName" => "BTC-LTC",
      "High" => 0.01350000,
      "Low" => 0.01200000,
      "Volume" => 3833.97619253,
      "Last" => 0.01349998,
      "BaseVolume" => 47.03987026,
      "TimeStamp" => "2014-07-09T07:22:16.72",
      "Bid" => 0.01271001,
      "Ask" => 0.01291100,
      "OpenBuyOrders" => 45,
      "OpenSellOrders" => 45,
      "PrevDay" => 0.01229501,
      "Created" => "2014-02-13T00:00:00",
      "DisplayMarketName" => nil
    }})

    assert {:ok, %MarketSummary{
      market: %Market{
        name: "BTC-LTC",
        created_at: ~N[2014-02-13 00:00:00],
      },
      ticker: %Ticker{
        bid: 0.01271001,
        ask: 0.01291100,
        last: 0.01349998,
      },
      high: 0.01350000,
      low: 0.01200000,
      previous_day: 0.01229501,
      volume: 3833.97619253,
      base_volume: 47.03987026,
      open_buy_orders: 45,
      open_sell_orders: 45,
    }} = GetMarketSummary.call(%Market{name: "BTC-LTC"})
  end
end
