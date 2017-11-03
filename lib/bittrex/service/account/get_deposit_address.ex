defmodule Bittrex.Service.Account.GetDepositAddress do
  use Bittrex.Service

  alias Bittrex.Data.Currency
  alias Bittrex.Parser.DepositAddressParser

  def call(%Currency{code: code}) do
    Request.new("/account/getdepositaddress", %{currency: code})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = DepositAddressParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
