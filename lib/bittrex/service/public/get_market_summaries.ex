defmodule Bittrex.Service.Public.GetMarketSummaries do
  use Bittrex.Service

  alias Bittrex.Parser.MarketSummaryParser

  def call do
    Request.new("/public/getmarketsummaries")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &MarketSummaryParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
