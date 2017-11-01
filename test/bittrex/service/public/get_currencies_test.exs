defmodule Bittrex.Service.Public.GetCurrenciesTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Currency, Request, Response}
  alias Bittrex.Service.Public.GetCurrencies

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /public/getcurrencies and returns list of Bittrex.Currency structs" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Currency" => "BTC",
      "CurrencyLong" => "Bitcoin",
      "MinConfirmation" => 2,
      "TxFee" => 0.00020000,
      "IsActive" => true,
      "CoinType" => "BITCOIN",
      "BaseAddress" => nil
    }, %{
      "Currency" => "LTC",
      "CurrencyLong" => "Litecoin",
      "MinConfirmation" => 5,
      "TxFee" => 0.00200000,
      "IsActive" => true,
      "CoinType" => "BITCOIN",
      "BaseAddress" => nil
    }]})

    assert {:ok, [%Currency{
      code: "BTC",
      name: "Bitcoin",
      active: true,
      transaction_fee: 0.00020000,
      minimum_confirmation: 2,
      coin_type: "BITCOIN",
      base_address: nil,
    }, %Currency{
      code: "LTC",
      name: "Litecoin",
      active: true,
      transaction_fee: 0.00200000,
      minimum_confirmation: 5,
      coin_type: "BITCOIN",
      base_address: nil,
    }]} = GetCurrencies.call()

    assert %Request{endpoint: "/public/getcurrencies", params: params} = InMemoryClient.pop()
    assert params == %{}
  end
end
