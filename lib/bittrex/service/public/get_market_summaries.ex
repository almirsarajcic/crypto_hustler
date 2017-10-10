defmodule Bittrex.Service.Public.GetMarketSummaries do
  use Bittrex.Service

  alias Bittrex.{Market, MarketSummary, Ticker}

  def call do
    Request.new("/public/getmarketsummaries")
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Enum.map(result, &parse_market_summary/1)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  defp parse_market_summary(result) do
    %MarketSummary{
      market: %Market{
        name: result["MarketName"],
        created_at: Bittrex.parse_datetime(result["Created"]),
      },
      ticker: %Ticker{
        bid: result["Bid"],
        ask: result["Ask"],
        last: result["Last"],
      },
      high: result["High"],
      low: result["Low"],
      previous_day: result["PrevDay"],
      volume: result["Volume"],
      base_volume: result["BaseVolume"],
      open_buy_orders: result["OpenBuyOrders"],
      open_sell_orders: result["OpenSellOrders"],
    }
  end
end
