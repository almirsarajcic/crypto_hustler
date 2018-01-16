defmodule Coinmarketcap.Data.Ticker do
  defstruct [:id, :name, :symbol, :rank, :usd_price, :btc_price, :volume, :market_cap, :available_supply, :total_supply, :max_supply, :percentage_change, :updated_at, :converted]
end
