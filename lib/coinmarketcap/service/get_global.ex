defmodule Coinmarketcap.Service.GetGlobal do
  alias Coinmarketcap.Data.Global
  alias Coinmarketcap.{Client, Request, Response}

  def call(fiat_currency \\ nil) do
    Request.new("/global/", %{convert: fiat_currency})
    |> Client.send()
    |> format_response(fiat_currency)
  end

  defp format_response(%Response{status: :ok, body: result}, fiat_currency) do
    btc_dominance = if result["bitcoin_percentage_of_market_cap"] do
      Float.round(result["bitcoin_percentage_of_market_cap"] / 100, 4)
    end
    updated_at = if result["last_updated"] do
      NaiveDateTime.add(~N[1970-01-01 00:00:00], result["last_updated"])
    end
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
      btc_dominance: btc_dominance,
      currencies: result["active_currencies"],
      assets: result["active_assets"],
      markets: result["active_markets"],
      updated_at: updated_at,
      converted: converted,
    }
    {:ok, global}
  end
  defp format_response(%Response{status: :error, body: reason}, _), do: {:error, reason}
end
