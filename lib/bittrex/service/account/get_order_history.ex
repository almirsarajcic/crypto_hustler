defmodule Bittrex.Service.Account.GetOrderHistory do
  use Bittrex.Service

  alias Bittrex.Data.{Market, Order}

  def call(market = %Market{} \\ %Market{}) do
    Request.new("/account/getorderhistory", get_params(market))
    |> Client.send()
    |> format_response()
  end

  # When sending %{market: nil} Bittrex returns "INVALID_MARKET" error,
  # unlike with Bittrex.Service.Market.GetOpenOrders
  def get_params(%Market{name: nil}), do: %{}
  def get_params(%Market{name: name}), do: %{market: name}

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &parse_order/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_order(result) do
    %Order{
      uuid: result["OrderUuid"],
      market: %Market{
        name: result["Exchange"],
      },
      opened_at: Bittrex.parse_datetime(result["TimeStamp"]),
      order_type: result["OrderType"],
      limit: result["Limit"],
      quantity: result["Quantity"],
      quantity_remaining: result["QuantityRemaining"],
      commission_paid: result["Commission"],
      rate: result["Price"],
      price_per_unit: result["PricePerUnit"],
      conditional: result["IsConditional"],
      condition: result["Condition"],
      condition_target: result["ConditionTarget"],
      immediate_or_cancel: result["ImmediateOrCancel"],
    }
  end
end
