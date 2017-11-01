defmodule Bittrex.Service.Market.BuyLimitTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Order, Request, Response}
  alias Bittrex.Service.Market.BuyLimit

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "creates buy order" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "uuid" => "e606d53c-8d70-11e3-94b5-425861b86ab6"
    }})

    assert {:ok, %Order{
      uuid: "e606d53c-8d70-11e3-94b5-425861b86ab6",
    }} = BuyLimit.call(%Market{name: "BTC-LTC"}, %Order{quantity: 1.2, rate: 1.3})

    assert %Request{endpoint: "/market/buylimit", params: params} = InMemoryClient.pop()
    assert params == %{market: "BTC-LTC", quantity: 1.2, rate: 1.3}
  end
end
