defmodule Bittrex.Service.Account.GetBalanceTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Data.{Balance, Currency}
  alias Bittrex.{Request, Response}
  alias Bittrex.Service.Account.GetBalance

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /account/getbalance and returns Bittrex.Balance struct" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "Currency" => "BTC",
      "Balance" => 4.21549076,
      "Available" => 4.21549076,
      "Pending" => 0.00000000,
      "CryptoAddress" => "1MacMr6715hjds342dXuLqXcju6fgwHA31",
      "Requested" => false,
      "Uuid" => nil
    }})

    assert {:ok, %Balance{
      currency: %Currency{
        code: "BTC",
      },
      balance: 4.21549076,
      available: 4.21549076,
      pending: 0.00000000,
      crypto_address: "1MacMr6715hjds342dXuLqXcju6fgwHA31",
      requested: false,
      uuid: nil,
    }} = GetBalance.call(%Currency{code: "BTC"})

    assert %Request{endpoint: "/account/getbalance", params: params} = InMemoryClient.pop()
    assert params == %{currency: "BTC"}
  end
end
