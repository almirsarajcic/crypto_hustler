defmodule Bittrex.Service.Account.Withdraw do
  use Bittrex.Service

  alias Bittrex.Data.{Currency, Withdrawal}

  def call(%Currency{code: code}, quantity, address) do
    Request.new("/account/withdraw", %{currency: code, quantity: quantity, address: address})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = parse_withdrawal(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_withdrawal(result) do
    %Withdrawal{
      uuid: result["Uuid"],
    }
  end
end
