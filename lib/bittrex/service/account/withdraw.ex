defmodule Bittrex.Service.Account.Withdraw do
  use Bittrex.Service

  alias Bittrex.{Currency, Withdrawal}

  def call(%Currency{code: code}, quantity, address) do
    Request.new("/account/withdraw", %{currency: code, quantity: quantity, address: address})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = parse_withdrawal(result)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  defp parse_withdrawal(result) do
    %Withdrawal{
      uuid: result["Uuid"],
    }
  end
end
