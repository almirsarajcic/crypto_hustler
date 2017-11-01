defmodule Bittrex.Data.Balance do
  alias Bittrex.Data.Currency

  defstruct [:currency, :balance, :available, :pending, :crypto_address, :requested, :uuid]

  def new(result) do
    %__MODULE__{
      currency: %Currency{
        code: result["Currency"],
      },
      balance: result["Balance"],
      available: result["Available"],
      pending: result["Pending"],
      crypto_address: result["CryptoAddress"],
      requested: result["Requested"],
      uuid: result["Uuid"],
    }
  end
end
