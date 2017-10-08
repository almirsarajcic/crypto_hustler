defmodule Bittrex.Currency do
  defstruct [:code, :name, :active, :transaction_fee, :minimum_confirmation, :coin_type, :base_address]
end
