defmodule Bittrex.Service.Market.BuyLimit do
  use Bittrex.Service

  alias Bittrex.{Market, Order}

  def call(%Market{name: name}, %Order{quantity: quantity, rate: rate}) do
    Request.new("/market/buylimit", %{market: name, quantity: quantity, rate: rate})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = parse_order(result)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  defp parse_order(result) do
    %Order{
      uuid: result["uuid"],
    }
  end
end
