defmodule Bittrex.Service.Account.GetBalances do
  use Bittrex.Service

  alias Bittrex.Parser.BalanceParser

  def call do
    Request.new("/account/getbalances")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &BalanceParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
