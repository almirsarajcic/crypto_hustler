defmodule Bittrex.Parser.CurrencyParser do
  alias Bittrex.Data.Currency

  def call(item, prefix \\ "") do
    %Currency{
      code: item[prefix <> "Currency"],
      name: item[prefix <> "CurrencyLong"],
      active: item["IsActive"],
      transaction_fee: item["TxFee"],
      minimum_confirmation: item["MinConfirmation"],
      coin_type: item["CoinType"],
      base_address: item["BaseAddress"],
    }
  end
end
