defmodule Bittrex.Service.Public.GetMarketHistory do
  use Bittrex.Service

  alias Bittrex.{Market, MarketHistory, Response}

  def call(%Market{name: name}) do
    Request.new("/public/getmarkethistory", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &parse_market_history/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_market_history(result) do
    %MarketHistory{
      id: result["Id"],
      created_at: Bittrex.parse_datetime(result["TimeStamp"]),
      quantity: result["Quantity"],
      price: result["Price"],
      total: result["Total"],
      fill_type: result["FillType"],
      order_type: result["OrderType"],
    }
  end
end
