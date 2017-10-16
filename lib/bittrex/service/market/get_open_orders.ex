defmodule Bittrex.Service.Market.GetOpenOrders do
  use Bittrex.Service

  alias Bittrex.{Market, Order}

  def call(%Market{name: name} \\ %Market{name: nil}) do
    Request.new("/market/getopenorders", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Enum.map(result, &parse_order/1)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  def parse_order(result) do
    %Order{
      uuid: result["OrderUuid"],
      market: %Market{
        name: result["Exchange"],
      },
      order_type: result["OrderType"],
      quantity: result["Quantity"],
      quantity_remaining: result["QuantityRemaining"],
      limit: result["Limit"],
      commission_paid: result["CommissionPaid"],
      rate: result["Price"],
      price_per_unit: result["PricePerUnit"],
      opened_at: Bittrex.parse_datetime(result["Opened"]),
      closed_at: Bittrex.parse_datetime(result["Closed"]),
      cancel_initiated: result["CancelInitiated"],
      immediate_or_cancel: result["ImmediateOrCancel"],
      conditional: result["IsConditional"],
      condition: result["Condition"],
      condition_target: result["ConditionTarget"],
    }
  end
end
