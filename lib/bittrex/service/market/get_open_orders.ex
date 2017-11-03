defmodule Bittrex.Service.Market.GetOpenOrders do
  use Bittrex.Service

  alias Bittrex.Data.Market
  alias Bittrex.Parser.OrderParser

  def call(%Market{name: name} \\ %Market{name: nil}) do
    Request.new("/market/getopenorders", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &OrderParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
