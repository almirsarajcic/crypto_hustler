defmodule Bittrex.Service.Public.GetOrderBook do
  use Bittrex.Service

  alias Bittrex.Data.{Market, Order, OrderBook}

  def call(%Market{name: name}, type) do
    Request.new("/public/getorderbook", %{market: name, type: type})
    |> Client.send()
    |> format_response(type)
  end

  defp format_response(%Response{status: :ok, body: result}, type) do
    response = parse_order_book(result, type)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}, _), do: {:error, reason}

  defp parse_order_book(result, type) do
    if type == "both" do
      %OrderBook{
        buy: Enum.map(result["buy"], &parse_order/1),
        sell: Enum.map(result["sell"], &parse_order/1),
      }
    else
      Map.put(%OrderBook{}, String.to_atom(type), Enum.map(result, &parse_order/1))
    end
  end

  defp parse_order(result) do
    %Order{
      quantity: result["Quantity"],
      rate: result["Rate"],
    }
  end
end
