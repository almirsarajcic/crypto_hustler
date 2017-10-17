defmodule Bittrex.Service.Account.GetWithdrawalHistory do
  use Bittrex.Service

  alias Bittrex.{Currency, Withdrawal}

  def call(currency = %Currency{} \\ %Currency{}) do
    Request.new("/account/getwithdrawalhistory", get_params(currency))
    |> Client.send()
    |> format_response()
  end

  # When sending %{currency: nil} Bittrex returns "INVALID_CURRENCY" error,
  # unlike with Bittrex.Service.Market.GetOpenOrders
  def get_params(%Currency{code: nil}), do: %{}
  def get_params(%Currency{code: code}), do: %{currency: code}

  defp format_response({:ok, result}) do
    response = Enum.map(result, &parse_withdrawal/1)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  def parse_withdrawal(result) do
    %Withdrawal{
      uuid: result["PaymentUuid"],
      currency: %Currency{
        code: result["Currency"],
      },
      amount: result["Amount"],
      address: result["Address"],
      opened_at: Bittrex.parse_datetime(result["Opened"]),
      authorized: result["Authorized"],
      pending: result["PendingPayment"],
      transaction_cost: result["TxCost"],
      transaction_id: result["TxId"],
      canceled: result["Canceled"],
      invalid_address: result["InvalidAddress"],
    }
  end
end
