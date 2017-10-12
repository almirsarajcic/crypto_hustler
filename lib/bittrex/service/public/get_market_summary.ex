defmodule Bittrex.Service.Public.GetMarketSummary do
  use Bittrex.Service

  alias Bittrex.{Market, MarketSummary}

  def call(%Market{name: name}) do
    Request.new("/public/getmarketsummary", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, [result]}) do
    response = MarketSummary.new(result)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}
end
