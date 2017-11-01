defmodule Bittrex.Service.Public.GetTicker do
  use Bittrex.Service

  alias Bittrex.Data.{Market, Ticker}

  def call(%Market{name: name}) do
    Request.new("/public/getticker", %{market: name})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = parse_ticker(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_ticker(result) do
    %Ticker{
      bid: result["Bid"],
      ask: result["Ask"],
      last: result["Last"],
    }
  end
end
