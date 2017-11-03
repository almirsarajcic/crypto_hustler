defmodule Bittrex.Service.Account.Withdraw do
  use Bittrex.Service

  alias Bittrex.Data.Currency
  alias Bittrex.Parser.WithdrawalParser

  def call(%Currency{code: code}, quantity, address) do
    Request.new("/account/withdraw", %{currency: code, quantity: quantity, address: address})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = WithdrawalParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
