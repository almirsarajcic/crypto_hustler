defmodule Bittrex.Service.Account.GetOrderHistoryTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Data.{Market, Order}
  alias Bittrex.{Request, Response}
  alias Bittrex.Service.Account.GetOrderHistory

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /account/getorderhistory and returns list of Bittrex.Order structs" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "OrderUuid" => "fd97d393-e9b9-4dd1-9dbf-f288fc72a185",
      "Exchange" => "BTC-LTC",
      "TimeStamp" => "2014-07-09T04:01:00.667",
      "OrderType" => "LIMIT_BUY",
      "Limit" => 0.00000001,
      "Quantity" => 100000.00000000,
      "QuantityRemaining" => 100000.00000000,
      "Commission" => 0.00000000,
      "Price" => 0.00000000,
      "PricePerUnit" => nil,
      "IsConditional" => false,
      "Condition" => nil,
      "ConditionTarget" => nil,
      "ImmediateOrCancel" => false
    }, %{
      "OrderUuid" => "17fd64d1-f4bd-4fb6-adb9-42ec68b8697d",
      "Exchange" => "BTC-ZS",
      "TimeStamp" => "2014-07-08T20:38:58.317",
      "OrderType" => "LIMIT_SELL",
      "Limit" => 0.00002950,
      "Quantity" => 667.03644955,
      "QuantityRemaining" => 0.00000000,
      "Commission" => 0.00004921,
      "Price" => 0.01968424,
      "PricePerUnit" => 0.00002950,
      "IsConditional" => false,
      "Condition" => nil,
      "ConditionTarget" => nil,
      "ImmediateOrCancel" => false
    }]})

    assert {:ok, [%Order{
      uuid: "fd97d393-e9b9-4dd1-9dbf-f288fc72a185",
      market: %Market{
        name: "BTC-LTC",
      },
      opened_at: ~N[2014-07-09 04:01:00.667],
      order_type: "LIMIT_BUY",
      limit: 0.00000001,
      quantity: 100000.00000000,
      quantity_remaining: 100000.00000000,
      commission_paid: 0.00000000,
      rate: 0.00000000,
      price_per_unit: nil,
      conditional: false,
      condition: nil,
      condition_target: nil,
      immediate_or_cancel: false,
    }, %Order{
      uuid: "17fd64d1-f4bd-4fb6-adb9-42ec68b8697d",
      market: %Market{
        name: "BTC-ZS",
      },
      opened_at: ~N[2014-07-08 20:38:58.317],
      order_type: "LIMIT_SELL",
      limit: 0.00002950,
      quantity: 667.03644955,
      quantity_remaining: 0.00000000,
      commission_paid: 0.00004921,
      rate: 0.01968424,
      price_per_unit: 0.00002950,
      conditional: false,
      condition: nil,
      condition_target: nil,
      immediate_or_cancel: false,
    }]} = GetOrderHistory.call()

    # TODO check that GetOrderHistory.call() sends requests with market in params
    assert [%Request{endpoint: "/account/getorderhistory", params: params}] = InMemoryClient.requests()
    assert params == %{}
  end
end
