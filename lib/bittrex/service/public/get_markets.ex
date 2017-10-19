defmodule Bittrex.Service.Public.GetMarkets do
  use Bittrex.Service

  alias Bittrex.{Currency, Market, Response}

  def call do
    Request.new("/public/getmarkets")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &parse_market/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_market(result) do
    %Market{
      name: result["MarketName"],
      minimum_trade: result["MinTradeSize"],
      active: result["IsActive"],
      created_at: Bittrex.parse_datetime(result["Created"]),
      base_currency: %Currency{
        code: result["BaseCurrency"],
        name: result["BaseCurrencyLong"],
      },
      market_currency: %Currency{
        code: result["MarketCurrency"],
        name: result["MarketCurrencyLong"],
      },
    }
  end
end
