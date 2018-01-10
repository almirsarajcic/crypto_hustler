defmodule Coinmarketcap.Service.GetGlobalTest do
  use ExUnit.Case

  alias Coinmarketcap.Client.InMemoryClient
  alias Coinmarketcap.Data.Global
  alias Coinmarketcap.{Request, Response}
  alias Coinmarketcap.Service.GetGlobal

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /global/ and returns Coinmarketcap.Global struct" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "total_market_cap_usd" => 201241796675,
      "total_24h_volume_usd" => 4548680009,
      "bitcoin_percentage_of_market_cap" => 62.54,
      "active_currencies" => 896,
      "active_assets" => 360,
      "active_markets" => 6439,
      "last_updated" => 1509909852
    }})

    assert {:ok, %Global{
      market_cap: 201241796675,
      volume: 4548680009,
      btc_dominance: 0.6254,
      currencies: 896,
      assets: 360,
      markets: 6439,
      updated_at: ~N[2017-11-05 19:24:12],
    }} = GetGlobal.call()

    assert [%Request{endpoint: "/global/", params: %{convert: nil}}] = InMemoryClient.requests()
  end

  test "sends request to /global/?convert=EUR" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "total_market_cap_usd" => 690725452883.0,
      "total_24h_volume_usd" => 49702565249.0,
      "bitcoin_percentage_of_market_cap" => 33.65,
      "active_currencies" => 900,
      "active_assets" => 487,
      "active_markets" => 7717,
      "last_updated" => 1515596061,
      "total_market_cap_eur" => 575820510894.0,
      "total_24h_volume_eur" => 41434344710.0
    }})

    assert {:ok, %Global{
      market_cap: 690725452883.0,
      volume: 49702565249.0,
      btc_dominance: 0.3365,
      currencies: 900,
      assets: 487,
      markets: 7717,
      updated_at: ~N[2018-01-10 14:54:21],
      converted: %{
        currency: "EUR",
        market_cap: 575820510894.0,
        volume: 41434344710.0,
      },
    }} = GetGlobal.call("EUR")

    assert [%Request{endpoint: "/global/", params: %{convert: "EUR"}}] = InMemoryClient.requests()
  end
end
