defmodule Bittrex.Parser.DepositParser do
  alias Bittrex.Data.Deposit
  alias Bittrex.Parser.CurrencyParser

  def call(item) do
    %Deposit{
      id: item["Id"],
      currency: CurrencyParser.call(item),
      amount: item["Amount"],
      address: item["CryptoAddress"],
      updated_at: Bittrex.parse_datetime(item["LastUpdated"]),
      transaction_id: item["TxId"],
    }
  end
end
