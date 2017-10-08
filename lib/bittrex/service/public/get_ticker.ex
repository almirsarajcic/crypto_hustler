defmodule Bittrex.Service.Public.GetTicker do
  use Bittrex.Service

  alias Bittrex.{Market, Ticker}

  def call(%Market{name: name} = market) do
    Request.new("/public/getticker", %{market: name})
    |> Client.send()
    |> format_response(market)
  end

  defp format_response({:ok, result}, market) do
    response = parse_ticker(result, market)
    {:ok, response}
  end
  defp format_response({:error, reason}, _), do: {:error, reason}

  defp parse_ticker(result, market) do
    %Ticker{
      market: market,
      bid: result["Bid"],
      ask: result["Ask"],
      last: result["Last"],
    }
  end
end
