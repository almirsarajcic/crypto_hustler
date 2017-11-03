defmodule Bittrex.Service.Public.GetMarketHistoryTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Data.{Market, MarketHistory}
  alias Bittrex.{Request, Response}
  alias Bittrex.Service.Public.GetMarketHistory

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /public/getmarkethistory and returns Bittrex.MarketHistory struct" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Id" => 319435,
      "TimeStamp" => "2014-07-09T03:21:20.08",
      "Quantity" => 0.30802438,
      "Price" => 0.01263400,
      "Total" => 0.00389158,
      "FillType" => "FILL",
      "OrderType" => "BUY"
    }, %{
      "Id" => 319433,
      "TimeStamp" => "2014-07-09T03:21:20.08",
      "Quantity" => 0.31820814,
      "Price" => 0.01262800,
      "Total" => 0.00401833,
      "FillType" => "PARTIAL_FILL",
      "OrderType" => "BUY"
    }, %{
      "Id" => 319379,
      "TimeStamp" => "2014-07-09T02:58:48.127",
      "Quantity" => 49.64643541,
      "Price" => 0.01263200,
      "Total" => 0.62713377,
      "FillType" => "FILL",
      "OrderType" => "SELL"
    }, %{
      "Id" => 319378,
      "TimeStamp" => "2014-07-09T02:58:46.27",
      "Quantity" => 0.35356459,
      "Price" => 0.01263200,
      "Total" => 0.00446622,
      "FillType" => "PARTIAL_FILL",
      "OrderType" => "BUY"
    }]})

    assert {:ok, [%MarketHistory{
      id: 319435,
      created_at: ~N[2014-07-09 03:21:20.08],
      quantity: 0.30802438,
      price: 0.01263400,
      total: 0.00389158,
      fill_type: "FILL",
      order_type: "BUY",
    }, %MarketHistory{
      id: 319433,
      created_at: ~N[2014-07-09 03:21:20.08],
      quantity: 0.31820814,
      price: 0.01262800,
      total: 0.00401833,
      fill_type: "PARTIAL_FILL",
      order_type: "BUY",
    }, %MarketHistory{
      id: 319379,
      created_at: ~N[2014-07-09 02:58:48.127],
      quantity: 49.64643541,
      price: 0.01263200,
      total: 0.62713377,
      fill_type: "FILL",
      order_type: "SELL",
    }, %MarketHistory{
      id: 319378,
      created_at: ~N[2014-07-09 02:58:46.27],
      quantity: 0.35356459,
      price: 0.01263200,
      total: 0.00446622,
      fill_type: "PARTIAL_FILL",
      order_type: "BUY",
    }]} = GetMarketHistory.call(%Market{name: "BTC-DOGE"})

    assert %Request{endpoint: "/public/getmarkethistory", params: params} = InMemoryClient.pop()
    assert params == %{market: "BTC-DOGE"}
  end
end
