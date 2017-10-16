defmodule Bittrex.Service.Account.GetBalances do
  use Bittrex.Service

  alias Bittrex.Balance

  def call do
    Request.new("/account/getbalances")
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Enum.map(result, &Balance.new/1)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}
end
