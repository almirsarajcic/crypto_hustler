defmodule Bittrex.Parser.DepositAddressParser do
  alias Bittrex.Data.DepositAddress
  alias Bittrex.Parser.CurrencyParser

  def call(item) do
    %DepositAddress{
      currency: CurrencyParser.call(item),
      address: item["Address"],
    }
  end
end
