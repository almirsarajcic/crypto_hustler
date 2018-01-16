defmodule Coinmarketcap.Service.GetTickersTest do
  use ExUnit.Case

  alias Coinmarketcap.Client.InMemoryClient
  alias Coinmarketcap.Data.Ticker
  alias Coinmarketcap.{Request, Response}
  alias Coinmarketcap.Service.GetTickers

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /ticker/ and returns Coinmarketcap.Ticker structs" do
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
      "percent_change_1h" => "0.04",
      "percent_change_24h" => "-0.3",
      "percent_change_7d" => "-0.57",
      "last_updated" => "1472762067",
    }, %{
      "id" => "ethereum",
      "name" => "Ethereum",
      "symbol" => "ETH",
      "rank" => "2",
      "price_usd" => "12.1844",
      "price_btc" => "0.021262",
      "24h_volume_usd" => "24085900.0",
      "market_cap_usd" => "1018098455.0",
      "available_supply" => "83557537.0",
      "total_supply" => "83557537.0",
      "percent_change_1h" => "-0.58",
      "percent_change_24h" => "6.34",
      "percent_change_7d" => "8.59",
      "last_updated" => "1472762062",
    }]})

    assert {:ok, [%Ticker{
      id: "ethereum",
      name: "Ethereum",
      symbol: "ETH",
      rank: 2,
      usd_price: 12.1844,
      btc_price: 0.021262,
      volume: 24085900.0,
      market_cap: 1018098455.0,
      available_supply: 83557537.0,
      total_supply: 83557537.0,
      percentage_change: %{
        hour: -0.0058,
        day: 0.0634,
        week: 0.0859,
      },
      updated_at: ~N[2016-09-01 20:34:22],
    }, %Ticker{
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
      percentage_change: %{
        hour: 0.0004,
        day: -0.003,
        week: -0.0057,
      },
      updated_at: ~N[2016-09-01 20:34:27],
    }]} = GetTickers.call(%{})

    assert [%Request{endpoint: "/ticker/", params: params}] = InMemoryClient.requests()
    assert params == %{}
  end

  test "sends request to /ticker/?convert=EUR" do
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
    }, %{
      "id" => "ethereum",
      "name" => "Ethereum",
      "symbol" => "ETH",
      "rank" => "2",
      "price_usd" => "1316.48",
      "price_btc" => "0.0917959",
      "24h_volume_usd" => "4787170000.0",
      "market_cap_usd" => "127691199312",
      "available_supply" => "96994409.0",
      "total_supply" => "96994409.0",
      "max_supply" => nil,
      "percent_change_1h" => "-0.2",
      "percent_change_24h" => "-0.24",
      "percent_change_7d" => "16.68",
      "last_updated" => "1516027449",
      "price_eur" => "1072.47964736",
      "24h_volume_eur" => "3899901550.69",
      "market_cap_eur" => "104024529358",
    }]})

    assert {:ok, [%Ticker{
      id: "ethereum",
      name: "Ethereum",
      symbol: "ETH",
      rank: 2,
      usd_price: 1316.48,
      btc_price: 0.0917959,
      volume: 4787170000.0,
      market_cap: 127691199312.0,
      available_supply: 96994409.0,
      total_supply: 96994409.0,
      max_supply: nil,
      percentage_change: %{
        hour: -0.002,
        day: -0.0024,
        week: 0.1668,
      },
      updated_at: ~N[2018-01-15 14:44:09],
      converted: %{
        currency: "EUR",
        price: 1072.47964736,
        market_cap: 104024529358.0,
        volume: 3899901550.69,
      },
    }, %Ticker{
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
    }]} = GetTickers.call(%{convert: "EUR"})

    assert [%Request{endpoint: "/ticker/", params: %{convert: "EUR"}}] = InMemoryClient.requests()
  end

  test "sends request to /ticker/?start=100&limit=10" do
    InMemoryClient.push(%Response{status: :ok, body: []})

    GetTickers.call(%{start: 100, limit: 10})

    assert [%Request{endpoint: "/ticker/", params: %{start: 100, limit: 10}}] = InMemoryClient.requests()
  end
end
