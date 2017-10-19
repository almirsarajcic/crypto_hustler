defmodule Bittrex.Service.Market.SellLimit do
  use Bittrex.Service

  alias Bittrex.{Market, Order, Response}

  def call(%Market{name: name}, %Order{quantity: quantity, rate: rate}) do
    Request.new("/market/selllimit", %{market: name, quantity: quantity, rate: rate})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Order.new(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
