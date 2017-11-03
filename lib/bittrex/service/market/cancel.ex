defmodule Bittrex.Service.Market.Cancel do
  use Bittrex.Service

  alias Bittrex.Data.Order

  def call(%Order{uuid: uuid}) do
    Request.new("/market/cancel", %{uuid: uuid})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: nil}), do: {:ok, nil}
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
