defmodule Bittrex.Service.Public.GetMarketSummaries do
  use Bittrex.Service

  alias Bittrex.{MarketSummary, Response}

  def call do
    Request.new("/public/getmarketsummaries")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &MarketSummary.new/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
