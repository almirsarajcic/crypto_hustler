defmodule Bittrex.Service.Public.GetTicker do
  use Bittrex.Service

  alias Bittrex.Data.Market
  alias Bittrex.Parser.TickerParser

  def call(%Market{name: name}) do
    Request.new("/public/getticker", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = TickerParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
