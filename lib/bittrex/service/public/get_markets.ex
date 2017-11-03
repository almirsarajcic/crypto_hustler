defmodule Bittrex.Service.Public.GetMarkets do
  use Bittrex.Service

  alias Bittrex.Parser.MarketParser

  def call do
    Request.new("/public/getmarkets")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &MarketParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
