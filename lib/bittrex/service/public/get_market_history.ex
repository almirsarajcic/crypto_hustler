defmodule Bittrex.Service.Public.GetMarketHistory do
  use Bittrex.Service

  alias Bittrex.Data.Market
  alias Bittrex.Parser.MarketHistoryParser

  def call(%Market{name: name}) do
    Request.new("/public/getmarkethistory", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &MarketHistoryParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
