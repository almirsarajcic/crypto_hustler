defmodule Bittrex.Service.Public.GetMarketsTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Currency, Market}
  alias Bittrex.Service.Public.GetMarkets

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns list of Bittrex.Market structs" do
    InMemoryClient.push({:ok, [%{
  			"MarketCurrency" => "LTC",
  			"BaseCurrency" => "BTC",
  			"MarketCurrencyLong" => "Litecoin",
  			"BaseCurrencyLong" => "Bitcoin",
  			"MinTradeSize" => 0.01000000,
  			"MarketName" => "BTC-LTC",
  			"IsActive" => true,
  			"Created" => "2014-02-13T00:00:00"
  		}, %{
  			"MarketCurrency" => "DOGE",
  			"BaseCurrency" => "BTC",
  			"MarketCurrencyLong" => "Dogecoin",
  			"BaseCurrencyLong" => "Bitcoin",
  			"MinTradeSize" => 100.00000000,
  			"MarketName" => "BTC-DOGE",
  			"IsActive" => true,
  			"Created" => "2014-02-13T00:00:00"
  		}
    ]})

    assert {:ok, [%Market{
      name: "BTC-LTC",
      minimum_trade: 0.01000000,
      active: true,
      created_at: ~N[2014-02-13 00:00:00],
      market_currency: %Currency{
        code: "LTC",
        name: "Litecoin",
      },
      base_currency: %Currency{
        code: "BTC",
        name: "Bitcoin",
      },
    }, %Market{
      name: "BTC-DOGE",
      minimum_trade: 100.00000000,
      active: true,
      created_at: ~N[2014-02-13 00:00:00],
      market_currency: %Currency{
        code: "DOGE",
        name: "Dogecoin",
      },
      base_currency: %Currency{
        code: "BTC",
        name: "Bitcoin",
      },
    }]} = GetMarkets.call()
  end
end
