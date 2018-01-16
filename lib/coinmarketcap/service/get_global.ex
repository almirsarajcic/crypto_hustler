defmodule Coinmarketcap.Service.GetGlobal do
  alias Coinmarketcap.Data.Global
  alias Coinmarketcap.{Client, Request, Response}

  def call(fiat_currency \\ nil) do
    Request.new("/global/", %{convert: fiat_currency})
    |> Client.send()
    |> format_response(fiat_currency)
  end

  defp format_response(%Response{status: :ok, body: result}, fiat_currency) do
    converted = if fiat_currency do
      lowercase = String.downcase(fiat_currency)

      %{
        currency: fiat_currency,
        market_cap: result["total_market_cap_" <> lowercase],
        volume: result["total_24h_volume_" <> lowercase],
      }
    end

    global = %Global{
      market_cap: result["total_market_cap_usd"],
      volume: result["total_24h_volume_usd"],
      btc_dominance: Coinmarketcap.calculate_percentage(result["bitcoin_percentage_of_market_cap"]),
      currencies: result["active_currencies"],
      assets: result["active_assets"],
      markets: result["active_markets"],
      updated_at: Coinmarketcap.parse_datetime(result["last_updated"]),
      converted: converted,
    }
    {:ok, global}
  end
  defp format_response(%Response{status: :error, body: reason}, _), do: {:error, reason}
end
