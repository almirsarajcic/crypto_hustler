defmodule Bittrex.Service.Public.GetOrderBook do
  use Bittrex.Service

  alias Bittrex.Data.Market
  alias Bittrex.Parser.OrderBookParser

  def call(%Market{name: name}, type) do
    Request.new("/public/getorderbook", %{market: name, type: type})
    |> Client.send()
    |> format_response(type)
  end

  defp format_response(%Response{status: :ok, body: result}, type) do
    response = OrderBookParser.call(result, type)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}, _), do: {:error, reason}
end
