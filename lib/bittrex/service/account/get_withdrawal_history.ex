defmodule Bittrex.Service.Account.GetWithdrawalHistory do
  use Bittrex.Service

  alias Bittrex.Data.Currency
  alias Bittrex.Parser.WithdrawalParser

  def call(currency = %Currency{} \\ %Currency{}) do
    Request.new("/account/getwithdrawalhistory", get_params(currency))
    |> Client.send()
    |> format_response()
  end

  # When sending %{currency: nil} Bittrex returns "INVALID_CURRENCY" error,
  # unlike with Bittrex.Service.Market.GetOpenOrders
  def get_params(%Currency{code: nil}), do: %{}
  def get_params(%Currency{code: code}), do: %{currency: code}

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &WithdrawalParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
