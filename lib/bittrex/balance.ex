defmodule Bittrex.Balance do
  defstruct [:currency, :balance, :available, :pending, :crypto_address, :requested, :uuid]
end
