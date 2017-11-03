defmodule Bittrex.Data.Deposit do
  defstruct [:id, :currency, :amount, :address, :updated_at, :transaction_id]
end
