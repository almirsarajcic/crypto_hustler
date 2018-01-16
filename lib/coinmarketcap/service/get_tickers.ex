defmodule Coinmarketcap.Service.GetTickers do
  alias Coinmarketcap.Data.Ticker
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
    converted = if fiat_currency do
      lowercase = String.downcase(fiat_currency)

      %{
        currency: fiat_currency,
        price: extract_float(head["price_" <> lowercase]),
        market_cap: extract_float(head["market_cap_" <> lowercase]),
        volume: extract_float(head["24h_volume_" <> lowercase]),
      }
    end

    ticker = %Ticker{
      id: head["id"],
      name: head["name"],
      symbol: head["symbol"],
      rank: String.to_integer(head["rank"]),
      usd_price: extract_float(head["price_usd"]),
      btc_price: extract_float(head["price_btc"]),
      volume: extract_float(head["24h_volume_usd"]),
      market_cap: extract_float(head["market_cap_usd"]),
      available_supply: extract_float(head["available_supply"]),
      total_supply: extract_float(head["total_supply"]),
      max_supply: extract_float(head["max_supply"]),
      percentage_change: %{
        hour: percentage_change(head, "percent_change_1h"),
        day: percentage_change(head, "percent_change_24h"),
        week: percentage_change(head, "percent_change_7d"),
      },
      updated_at: NaiveDateTime.add(~N[1970-01-01 00:00:00], String.to_integer(head["last_updated"])),
      converted: converted
    }

    parse_tickers(tail, fiat_currency, [ticker|tickers])
  end

  defp percentage_change(head, field) do
    Float.round(extract_float(head[field]) / 100, 4)
  end

  defp extract_float(nil), do: nil
  defp extract_float(string) do
    unless Regex.match?(~r/\./, string) do
      string = string <> ".0"
    end

    String.to_float(string)
  end
end
