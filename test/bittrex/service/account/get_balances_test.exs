defmodule Bittrex.Service.Account.GetBalancesTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Data.{Balance, Currency}
  alias Bittrex.{Request, Response}
  alias Bittrex.Service.Account.GetBalances

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /account/getbalances and returns list of Bittrex.Balance structs" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Currency" => "DOGE",
      "Balance" => 0.00000000,
      "Available" => 0.00000000,
      "Pending" => 0.00000000,
      "CryptoAddress" => "DLxcEt3AatMyr2NTatzjsfHNoB9NT62HiF",
      "Requested" => false,
      "Uuid" => nil
    }, %{
      "Currency" => "BTC",
      "Balance" => 14.21549076,
      "Available" => 14.21549076,
      "Pending" => 0.00000000,
      "CryptoAddress" => "1Mrcdr6715hjda34pdXuLqXcju6qgwHA31",
      "Requested" => false,
      "Uuid" => nil
    }]})

    assert {:ok, [%Balance{
      currency: %Currency{
        code: "DOGE",
      },
      balance: 0.00000000,
      available: 0.00000000,
      pending: 0.00000000,
      crypto_address: "DLxcEt3AatMyr2NTatzjsfHNoB9NT62HiF",
      requested: false,
      uuid: nil,
    }, %Balance{
      currency: %Currency{
        code: "BTC",
      },
      balance: 14.21549076,
      available: 14.21549076,
      pending: 0.00000000,
      crypto_address: "1Mrcdr6715hjda34pdXuLqXcju6qgwHA31",
      requested: false,
      uuid: nil,
    }]} = GetBalances.call()

    assert %Request{endpoint: "/account/getbalances", params: params} = InMemoryClient.pop()
    assert params == %{}
  end
end
