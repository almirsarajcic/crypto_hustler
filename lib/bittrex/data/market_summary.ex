defmodule Bittrex.Data.MarketSummary do
  defstruct [:market, :ticker, :high, :low, :previous_day, :volume, :base_volume, :open_buy_orders, :open_sell_orders]
end
