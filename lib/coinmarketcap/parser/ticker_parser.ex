defmodule Coinmarketcap.Parser.TickerParser do
  alias Coinmarketcap.Data.Ticker

  def call(item, fiat_currency) do
    converted = if fiat_currency do
      lowercase = String.downcase(fiat_currency)

      %{
        currency: fiat_currency,
        price: extract_float(item["price_" <> lowercase]),
        market_cap: extract_float(item["market_cap_" <> lowercase]),
        volume: extract_float(item["24h_volume_" <> lowercase]),
      }
    end

    %Ticker{
      id: item["id"],
      name: item["name"],
      symbol: item["symbol"],
      rank: String.to_integer(item["rank"]),
      usd_price: extract_float(item["price_usd"]),
      btc_price: extract_float(item["price_btc"]),
      volume: extract_float(item["24h_volume_usd"]),
      market_cap: extract_float(item["market_cap_usd"]),
      available_supply: extract_float(item["available_supply"]),
      total_supply: extract_float(item["total_supply"]),
      max_supply: extract_float(item["max_supply"]),
      percentage_change: %{
        hour: percentage_change(item["percent_change_1h"]),
        day: percentage_change(item["percent_change_24h"]),
        week: percentage_change(item["percent_change_7d"]),
      },
      updated_at: NaiveDateTime.add(~N[1970-01-01 00:00:00], String.to_integer(item["last_updated"])),
      converted: converted
    }
  end

  defp percentage_change(nil), do: nil
  defp percentage_change(string), do: Float.round(extract_float(string) / 100, 4)

  defp extract_float(nil), do: nil
  defp extract_float(string) do
    string = if Regex.match?(~r/\./, string) do
      string
    else
      string <> ".0"
    end

    String.to_float(string)
  end
end
