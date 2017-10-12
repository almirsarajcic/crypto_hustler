defmodule Bittrex.Service.Market.SellLimitTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Order}
  alias Bittrex.Service.Market.SellLimit

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "creates sell order" do
    InMemoryClient.push({:ok, %{
      "uuid" => "614c34e4-8d71-11e3-94b5-425861b86ab6"
    }})

    assert {:ok, %Order{
      uuid: "614c34e4-8d71-11e3-94b5-425861b86ab6",
    }} = SellLimit.call(%Market{name: "BTC-LTC"}, %Order{quantity: 1.2, rate: 1.3})
  end
end
