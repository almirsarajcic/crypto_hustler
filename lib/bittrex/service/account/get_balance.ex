defmodule Bittrex.Service.Account.GetBalance do
  use Bittrex.Service

  alias Bittrex.{Balance, Currency}

  def call(%Currency{code: code}) do
    Request.new("/account/getbalance", %{currency: code})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Balance.new(result)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}
end
