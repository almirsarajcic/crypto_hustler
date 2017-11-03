defmodule Bittrex.Service.Public.GetCurrencies do
  use Bittrex.Service

  alias Bittrex.Parser.CurrencyParser

  def call do
    Request.new("/public/getcurrencies")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &CurrencyParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
