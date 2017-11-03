defmodule Bittrex.Service.Account.GetDepositHistory do
  use Bittrex.Service

  alias Bittrex.Data.Currency
  alias Bittrex.Parser.DepositParser

  def call(currency = %Currency{} \\ %Currency{}) do
    Request.new("/account/getdeposithistory", get_params(currency))
    |> Client.send()
    |> format_response()
  end

  # When sending %{currency: nil} Bittrex returns "INVALID_CURRENCY" error,
  # unlike with Bittrex.Service.Market.GetOpenOrders
  def get_params(%Currency{code: nil}), do: %{}
  def get_params(%Currency{code: code}), do: %{currency: code}

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &DepositParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
