defmodule Bittrex.Service.Market.GetOpenOrdersTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Order, Response}
  alias Bittrex.Service.Market.GetOpenOrders

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns list of Bittrex.Order structs" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Uuid" => nil,
      "OrderUuid" => "09aa5bb6-8232-41aa-9b78-a5a1093e0211",
      "Exchange" => "BTC-LTC",
      "OrderType" => "LIMIT_SELL",
      "Quantity" => 5.00000000,
      "QuantityRemaining" => 5.00000000,
      "Limit" => 2.00000000,
      "CommissionPaid" => 0.00000000,
      "Price" => 0.00000000,
      "PricePerUnit" => nil,
      "Opened" => "2014-07-09T03:55:48.77",
      "Closed" => nil,
      "CancelInitiated" => false,
      "ImmediateOrCancel" => false,
      "IsConditional" => false,
      "Condition" => nil,
      "ConditionTarget" => nil
    }, %{
      "Uuid" => nil,
      "OrderUuid" => "8925d746-bc9f-4684-b1aa-e507467aaa99",
      "Exchange" => "BTC-LTC",
      "OrderType" => "LIMIT_BUY",
      "Quantity" => 100000.00000000,
      "QuantityRemaining" => 100000.00000000,
      "Limit" => 0.00000001,
      "CommissionPaid" => 0.00000000,
      "Price" => 0.00000000,
      "PricePerUnit" => nil,
      "Opened" => "2014-07-09T03:55:48.583",
      "Closed" => nil,
      "CancelInitiated" => false,
      "ImmediateOrCancel" => false,
      "IsConditional" => false,
      "Condition" => nil,
      "ConditionTarget" => nil
    }]})

    assert {:ok, [%Order{
      uuid: "09aa5bb6-8232-41aa-9b78-a5a1093e0211",
      market: %Market{
        name: "BTC-LTC",
      },
      order_type: "LIMIT_SELL",
      quantity: 5.00000000,
      quantity_remaining: 5.00000000,
      limit: 2.00000000,
      commission_paid: 0.00000000,
      rate: 0.00000000,
      price_per_unit: nil,
      opened_at: ~N[2014-07-09 03:55:48.77],
      closed_at: nil,
      cancel_initiated: false,
      immediate_or_cancel: false,
      conditional: false,
      condition: nil,
      condition_target: nil,
    }, %Order{
      uuid: "8925d746-bc9f-4684-b1aa-e507467aaa99",
      market: %Market{
        name: "BTC-LTC",
      },
      order_type: "LIMIT_BUY",
      quantity: 100000.00000000,
      quantity_remaining: 100000.00000000,
      limit: 0.00000001,
      commission_paid: 0.00000000,
      rate: 0.00000000,
      price_per_unit: nil,
      opened_at: ~N[2014-07-09 03:55:48.583],
      closed_at: nil,
      cancel_initiated: false,
      immediate_or_cancel: false,
      conditional: false,
      condition: nil,
      condition_target: nil,
    }]} = GetOpenOrders.call(%Market{name: "BTC-LTC"})
  end
end
