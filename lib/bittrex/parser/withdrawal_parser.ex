defmodule Bittrex.Parser.WithdrawalParser do
  alias Bittrex.Data.Withdrawal
  alias Bittrex.Parser.CurrencyParser

  def call(item) do
    %Withdrawal{
      uuid: item["PaymentUuid"] || item["Uuid"],
      currency: CurrencyParser.call(item),
      amount: item["Amount"],
      address: item["Address"],
      opened_at: Bittrex.parse_datetime(item["Opened"]),
      authorized: item["Authorized"],
      pending: item["PendingPayment"],
      transaction_cost: item["TxCost"],
      transaction_id: item["TxId"],
      canceled: item["Canceled"],
      invalid_address: item["InvalidAddress"],
    }
  end
end
