defmodule Bittrex.Service.Public.GetOrderBookTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Order, OrderBook, Request, Response}
  alias Bittrex.Service.Public.GetOrderBook

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /public/getorderbook and returns Bittrex.OrderBook struct with both buy and sell orders" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "buy" => [%{
        "Quantity" => 12.37000000,
        "Rate" => 0.02525000
      }],
      "sell" => [%{
        "Quantity" => 32.55412402,
        "Rate" => 0.02540000
      }, %{
        "Quantity" => 60.00000000,
        "Rate" => 0.02550000
      }, %{
        "Quantity" => 60.00000000,
        "Rate" => 0.02575000
      }, %{
        "Quantity" => 84.00000000,
        "Rate" => 0.02600000
      }],
    }})

    assert {:ok, %OrderBook{
      buy: [
        %Order{
          quantity: 12.37000000,
          rate: 0.02525000,
        },
      ],
      sell: [
        %Order{
          quantity: 32.55412402,
          rate: 0.02540000,
        },
        %Order {
          quantity: 60.00000000,
          rate: 0.02550000,
        },
        %Order {
          quantity: 60.00000000,
          rate: 0.02575000,
        },
        %Order {
          quantity: 84.00000000,
          rate: 0.02600000,
        },
      ],
    }} = GetOrderBook.call(%Market{name: "BTC-LTC"}, "both")

    assert %Request{endpoint: "/public/getorderbook", params: params} = InMemoryClient.pop()
    assert params == %{market: "BTC-LTC", type: "both"}
  end

  test "sends request to /public/getorderbook and returns Bittrex.OrderBook struct with only one type of orders" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Quantity" => 32.55412402,
      "Rate" => 0.02540000
    }, %{
      "Quantity" => 60.00000000,
      "Rate" => 0.02550000
    }, %{
      "Quantity" => 60.00000000,
      "Rate" => 0.02575000
    }, %{
      "Quantity" => 84.00000000,
      "Rate" => 0.02600000
    }]})

    assert {:ok, %OrderBook{
      sell: [
        %Order{
          quantity: 32.55412402,
          rate: 0.02540000,
        },
        %Order {
          quantity: 60.00000000,
          rate: 0.02550000,
        },
        %Order {
          quantity: 60.00000000,
          rate: 0.02575000,
        },
        %Order {
          quantity: 84.00000000,
          rate: 0.02600000,
        },
      ],
    }} = GetOrderBook.call(%Market{name: "BTC-LTC"}, "sell")

    assert %Request{endpoint: "/public/getorderbook", params: params} = InMemoryClient.pop()
    assert params == %{market: "BTC-LTC", type: "sell"}
  end
end
