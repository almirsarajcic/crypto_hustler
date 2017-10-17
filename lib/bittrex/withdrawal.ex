defmodule Bittrex.Withdrawal do
  defstruct [:uuid, :currency, :amount, :address, :opened_at, :authorized, :pending, :transaction_cost, :transaction_id, :canceled, :invalid_address]
end
