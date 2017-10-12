defmodule Bittrex.Service.Market.Cancel do
  use Bittrex.Service

  alias Bittrex.Order

  def call(%Order{uuid: uuid}) do
    Request.new("/market/cancel", %{uuid: uuid})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, nil}), do: {:ok, nil}
  defp format_response({:error, reason}), do: {:error, reason}
end
