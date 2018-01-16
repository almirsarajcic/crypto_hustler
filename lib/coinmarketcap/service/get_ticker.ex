defmodule Coinmarketcap.Service.GetTicker do
  alias Coinmarketcap.Parser.TickerParser
  alias Coinmarketcap.{Client, Request, Response}

  def call(id, fiat_currency \\ nil) do
    Request.new("/ticker/" <> id <> "/", %{convert: fiat_currency})
    |> Client.send()
    |> format_response(fiat_currency)
  end

  defp format_response(%Response{status: :ok, body: result}, fiat_currency) do
    response = parse_tickers(result, fiat_currency)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}, _), do: {:error, reason}

  defp parse_tickers(_, _, tickers \\ [])
  defp parse_tickers([], _, tickers), do: tickers
  defp parse_tickers([head|tail], fiat_currency, tickers) do
    ticker = TickerParser.call(head, fiat_currency)
    parse_tickers(tail, fiat_currency, [ticker|tickers])
  end
end
