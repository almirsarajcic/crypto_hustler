defmodule Bittrex.Service.Account.GetOrderTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Market, Order, Response}
  alias Bittrex.Service.Account.GetOrder

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns Bittrex.Order struct" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "AccountId" => nil,
      "OrderUuid" => "0cb4c4e4-bdc7-4e13-8c13-430e587d2cc1",
      "Exchange" => "BTC-SHLD",
      "Type" => "LIMIT_BUY",
      "Quantity" => 1000.00000000,
      "QuantityRemaining" => 1000.00000000,
      "Limit" => 0.00000001,
      "Reserved" => 0.00001000,
      "ReserveRemaining" => 0.00001000,
      "CommissionReserved" => 0.00000002,
      "CommissionReserveRemaining" => 0.00000002,
      "CommissionPaid" => 0.00000000,
      "Price" => 0.00000000,
      "PricePerUnit" => nil,
      "Opened" => "2014-07-13T07:45:46.27",
      "Closed" => nil,
      "IsOpen" => true,
      "Sentinel" => "6c454604-22e2-4fb4-892e-179eede20972",
      "CancelInitiated" => false,
      "ImmediateOrCancel" => false,
      "IsConditional" => false,
      "Condition" => "NONE",
      "ConditionTarget" => nil
    }})

    assert {:ok, %Order{
      uuid: "0cb4c4e4-bdc7-4e13-8c13-430e587d2cc1",
      account_id: nil,
      market: %Market{
        name: "BTC-SHLD",
      },
      order_type: "LIMIT_BUY",
      quantity: 1000.00000000,
      quantity_remaining: 1000.00000000,
      limit: 0.00000001,
      reserved: 0.00001000,
      reserve_remaining: 0.00001000,
      commision_reserved: 0.00000002,
      commision_reserve_remaining: 0.00000002,
      commission_paid: 0.00000000,
      rate: 0.00000000,
      price_per_unit: nil,
      opened_at: ~N[2014-07-13 07:45:46.27],
      closed_at: nil,
      open: true,
      sentinel: "6c454604-22e2-4fb4-892e-179eede20972",
      cancel_initiated: false,
      immediate_or_cancel: false,
      conditional: false,
      condition: "NONE",
      condition_target: nil,
    }} = GetOrder.call(%Order{uuid: "0cb4c4e4-bdc7-4e13-8c13-430e587d2cc1"})
  end
end
