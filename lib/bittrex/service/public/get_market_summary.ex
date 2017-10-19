defmodule Bittrex.Service.Public.GetMarketSummary do
  use Bittrex.Service

  alias Bittrex.{Market, MarketSummary, Response}

  def call(%Market{name: name}) do
    Request.new("/public/getmarketsummary", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: [result]}) do
    response = MarketSummary.new(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
