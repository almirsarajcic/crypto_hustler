defmodule Bittrex.Data.MarketSummary do
  alias Bittrex.Data.{Market, Ticker}

  defstruct [:market, :ticker, :high, :low, :previous_day, :volume, :base_volume, :open_buy_orders, :open_sell_orders]

  def new(result) do
    %__MODULE__{
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
