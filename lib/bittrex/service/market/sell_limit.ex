defmodule Bittrex.Service.Market.SellLimit do
  use Bittrex.Service

  alias Bittrex.{Market, Order}

  def call(%Market{name: name}, %Order{quantity: quantity, rate: rate}) do
    Request.new("/market/selllimit", %{market: name, quantity: quantity, rate: rate})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Order.new(result)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}
end
