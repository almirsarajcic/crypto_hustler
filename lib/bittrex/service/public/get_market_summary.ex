defmodule Bittrex.Service.Public.GetMarketSummary do
  use Bittrex.Service

  alias Bittrex.Data.Market
  alias Bittrex.Parser.MarketSummaryParser

  def call(%Market{name: name}) do
    Request.new("/public/getmarketsummary", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: [result]}) do
    response = MarketSummaryParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
