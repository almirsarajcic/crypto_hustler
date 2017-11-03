defmodule Bittrex.Service.Account.GetBalance do
  use Bittrex.Service

  alias Bittrex.Data.Currency
  alias Bittrex.Parser.BalanceParser

  def call(%Currency{code: code}) do
    Request.new("/account/getbalance", %{currency: code})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = BalanceParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
