defmodule Bittrex.Service.Account.GetBalance do
  use Bittrex.Service

  alias Bittrex.{Balance, Currency, Response}

  def call(%Currency{code: code}) do
    Request.new("/account/getbalance", %{currency: code})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Balance.new(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
