defmodule Coinmarketcap.Service.GetTickerTest do
  use ExUnit.Case

  alias Coinmarketcap.Client.InMemoryClient
  alias Coinmarketcap.Data.Ticker
  alias Coinmarketcap.{Request, Response}
  alias Coinmarketcap.Service.GetTicker

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /ticker/bitcoin/ and returns Coinmarketcap.Ticker struct" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "id" => "bitcoin",
      "name" => "Bitcoin",
      "symbol" => "BTC",
      "rank" => "1",
      "price_usd" => "573.137",
      "price_btc" => "1.0",
      "24h_volume_usd" => "72855700.0",
      "market_cap_usd" => "9080883500.0",
      "available_supply" => "15844176.0",
      "total_supply" => "15844176.0",
      "max_supply" => "21000000.0",
      "percent_change_1h" => "0.04",
      "percent_change_24h" => "-0.3",
      "percent_change_7d" => "-0.57",
      "last_updated" => "1472762067",
    }]})

    assert {:ok, [%Ticker{
      id: "bitcoin",
      name: "Bitcoin",
      symbol: "BTC",
      rank: 1,
      usd_price: 573.137,
      btc_price: 1.0,
      volume: 72855700.0,
      market_cap: 9080883500.0,
      available_supply: 15844176.0,
      total_supply: 15844176.0,
      max_supply: 21000000.0,
      percentage_change: %{
        hour: 0.0004,
        day: -0.003,
        week: -0.0057,
      },
      updated_at: ~N[2016-09-01 20:34:27],
    }]} = GetTicker.call("bitcoin")

    assert [%Request{endpoint: "/ticker/bitcoin/", params: %{convert: nil}}] = InMemoryClient.requests()
  end

  test "sends request to /ticker/bitcoin/?convert=EUR" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "id" => "bitcoin",
      "name" => "Bitcoin",
      "symbol" => "BTC",
      "rank" => "1",
      "price_usd" => "14399.7",
      "price_btc" => "1.0",
      "24h_volume_usd" => "12250200000.0",
      "market_cap_usd" => "241975438740",
      "available_supply" => "16804200.0",
      "total_supply" => "16804200.0",
      "max_supply" => "21000000.0",
      "percent_change_1h" => "0.79",
      "percent_change_24h" => "6.16",
      "percent_change_7d" => "-5.33",
      "last_updated" => "1516027463",
      "price_eur" => "11730.8164029",
      "24h_volume_eur" => "9979711181.4",
      "market_cap_eur" => "197126984998",
    }]})

    assert {:ok, [%Ticker{
      id: "bitcoin",
      name: "Bitcoin",
      symbol: "BTC",
      rank: 1,
      usd_price: 14399.7,
      btc_price: 1.0,
      volume: 12250200000.0,
      market_cap: 241975438740.0,
      available_supply: 16804200.0,
      total_supply: 16804200.0,
      max_supply: 21000000.0,
      percentage_change: %{
        hour: 0.0079,
        day: 0.0616,
        week: -0.0533,
      },
      updated_at: ~N[2018-01-15 14:44:23],
      converted: %{
        currency: "EUR",
        price: 11730.8164029,
        market_cap: 197126984998.0,
        volume: 9979711181.4,
      },
    }]} = GetTicker.call("bitcoin", "EUR")

    assert [%Request{endpoint: "/ticker/bitcoin/", params: %{convert: "EUR"}}] = InMemoryClient.requests()
  end
end
