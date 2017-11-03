defmodule Bittrex.Data.Balance do
  defstruct [:currency, :balance, :available, :pending, :crypto_address, :requested, :uuid]
end
