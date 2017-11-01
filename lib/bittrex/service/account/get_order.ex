defmodule Bittrex.Service.Account.GetOrder do
  use Bittrex.Service

  alias Bittrex.Data.{Market, Order}

  def call(%Order{uuid: uuid}) do
    Request.new("/account/getorder", %{uuid: uuid})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = parse_order(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_order(result) do
    %Order{
      uuid: result["OrderUuid"],
      account_id: result["AccountId"],
      market: %Market{
        name: result["Exchange"],
      },
      order_type: result["Type"],
      quantity: result["Quantity"],
      quantity_remaining: result["QuantityRemaining"],
      limit: result["Limit"],
      reserved: result["Reserved"],
      reserve_remaining: result["ReserveRemaining"],
      commision_reserved: result["CommissionReserved"],
      commision_reserve_remaining: result["CommissionReserveRemaining"],
      commission_paid: result["CommissionPaid"],
      rate: result["Price"],
      price_per_unit: result["PricePerUnit"],
      opened_at: Bittrex.parse_datetime(result["Opened"]),
      closed_at: Bittrex.parse_datetime(result["Closed"]),
      open: result["IsOpen"],
      sentinel: result["Sentinel"],
      cancel_initiated: result["CancelInitiated"],
      immediate_or_cancel: result["ImmediateOrCancel"],
      conditional: result["IsConditional"],
      condition: result["Condition"],
      condition_target: result["ConditionTarget"],
    }
  end
end
