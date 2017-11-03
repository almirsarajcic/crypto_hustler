defmodule Bittrex.Parser.BalanceParser do
  alias Bittrex.Data.Balance
  alias Bittrex.Parser.CurrencyParser

  def call(item) do
    %Balance{
      currency: CurrencyParser.call(item),
      balance: item["Balance"],
      available: item["Available"],
      pending: item["Pending"],
      crypto_address: item["CryptoAddress"],
      requested: item["Requested"],
      uuid: item["Uuid"],
    }
  end
end
