defmodule Bittrex.Service.Public.GetMarketSummaries do
  use Bittrex.Service

  alias Bittrex.MarketSummary

  def call do
    Request.new("/public/getmarketsummaries")
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Enum.map(result, &MarketSummary.new/1)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}
end
