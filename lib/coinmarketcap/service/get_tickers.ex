defmodule Coinmarketcap.Service.GetTickers do
  alias Coinmarketcap.Parser.TickerParser
  alias Coinmarketcap.{Client, Request, Response}

  def call(params \\ %{}) do
    Request.new("/ticker/", params)
    |> Client.send()
    |> format_response(params[:convert])
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
