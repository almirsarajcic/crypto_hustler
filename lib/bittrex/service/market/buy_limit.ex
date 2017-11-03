defmodule Bittrex.Service.Market.BuyLimit do
  use Bittrex.Service

  alias Bittrex.Data.{Market, Order}
  alias Bittrex.Parser.OrderParser

  def call(%Market{name: name}, %Order{quantity: quantity, rate: rate}) do
    Request.new("/market/buylimit", %{market: name, quantity: quantity, rate: rate})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = OrderParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
