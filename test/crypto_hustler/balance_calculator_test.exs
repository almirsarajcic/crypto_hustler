defmodule CryptoHustler.BalanceCalculatorTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Response
  alias CryptoHustler.BalanceCalculator

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "calculates estimated BTC balance based on current prices" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Ask" => 0.02712209,
      "BaseVolume" => 1197.90220089,
      "Bid" => 0.02712196,
      "Created" => "2017-11-20T21:49:15.983",
      "High" => 0.0286999,
      "Last" => 0.02712209,
      "Low" => 0.02660000,
      "MarketName" => "BTC-BTG",
      "OpenBuyOrders" => 1364,
      "OpenSellOrders" => 16633,
      "PrevDay" => 0.02850000,
      "TimeStamp" => "2017-12-04T13:45:13.83",
      "Volume" => 43438.71861523
    }, %{
      "Ask" => 0.00004091,
      "BaseVolume" => 12668.63873056,
      "Bid" => 0.00004086,
      "Created" => "2014-03-03T09:00:00",
      "High" => 0.00004434,
      "Last" => 0.00004086,
      "Low" => 0.00003237,
      "MarketName" => "BTC-NXT",
      "OpenBuyOrders" => 3392,
      "OpenSellOrders" => 6588,
      "PrevDay" => 0.00003236,
      "TimeStamp" => "2017-12-04T13:45:19.203",
      "Volume" => 318114681.95070386
    }, %{
      "Ask" => 0.00002165,
      "BaseVolume" => 919.25522308,
      "Bid" => 0.00002161,
      "Created" => "2014-12-22T19:30:27.45",
      "High" => 0.00002236,
      "Last" => 0.00002165,
      "Low" => 0.00002125,
      "MarketName" => "BTC-XRP",
      "OpenBuyOrders" => 2162,
      "OpenSellOrders" => 24666,
      "PrevDay" => 0.00002180,
      "TimeStamp" => "2017-12-04T13:45:19.157",
      "Volume" => 42433675.0310635
    }]})

    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Available" => 0.00000003,
      "Balance" => 0.00000003,
      "CryptoAddress" => "wAll3Taddr355",
      "Currency" => "BTC",
      "Pending" => 0.00000000
    }, %{
      "Available" => 0.00000000,
      "Balance" => 0.00779119,
      "CryptoAddress" => nil,
      "Currency" => "BTG",
      "Pending" => 0.00000000
    }, %{
      "Available" => 76.42821529,
      "Balance" => 76.42821529,
      "CryptoAddress" => nil,
      "Currency" => "NXT",
      "Pending" => 0.00000000
    }, %{
      "Available" => 0.00000000,
      "Balance" => 0.00000000,
      "CryptoAddress" => nil,
      "Currency" => "XRP",
      "Pending" => 0.00000000
    }]})

    assert BalanceCalculator.get_estimated_btc_balance() == 0.00333420
  end
end
