defmodule Bittrex.Data.MarketHistory do
  defstruct [:id, :created_at, :quantity, :price, :total, :fill_type, :order_type]
end
