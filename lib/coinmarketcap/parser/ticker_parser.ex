defmodule Coinmarketcap.Parser.TickerParser do
  alias Coinmarketcap.Data.Ticker

  def call(item, fiat_currency) do
    converted = if fiat_currency do
      lowercase = String.downcase(fiat_currency)

      %{
        currency: fiat_currency,
        price: Coinmarketcap.extract_float(item["price_" <> lowercase]),
        market_cap: Coinmarketcap.extract_float(item["market_cap_" <> lowercase]),
        volume: Coinmarketcap.extract_float(item["24h_volume_" <> lowercase]),
      }
    end

    %Ticker{
      id: item["id"],
      name: item["name"],
      symbol: item["symbol"],
      rank: String.to_integer(item["rank"]),
      usd_price: Coinmarketcap.extract_float(item["price_usd"]),
      btc_price: Coinmarketcap.extract_float(item["price_btc"]),
      volume: Coinmarketcap.extract_float(item["24h_volume_usd"]),
      market_cap: Coinmarketcap.extract_float(item["market_cap_usd"]),
      available_supply: Coinmarketcap.extract_float(item["available_supply"]),
      total_supply: Coinmarketcap.extract_float(item["total_supply"]),
      max_supply: Coinmarketcap.extract_float(item["max_supply"]),
      percentage_change: %{
        hour: Coinmarketcap.calculate_percentage(item["percent_change_1h"]),
        day: Coinmarketcap.calculate_percentage(item["percent_change_24h"]),
        week: Coinmarketcap.calculate_percentage(item["percent_change_7d"]),
      },
      updated_at: Coinmarketcap.parse_datetime(item["last_updated"]),
      converted: converted
    }
  end
end
