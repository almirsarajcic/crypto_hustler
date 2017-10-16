defmodule Bittrex.Service.Account.GetBalanceTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Balance, Currency}
  alias Bittrex.Service.Account.GetBalance

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns Bittrex.Balance struct" do
    InMemoryClient.push({:ok, %{
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
  end
end
