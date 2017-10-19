defmodule Bittrex.Service.Account.GetDepositAddress do
  use Bittrex.Service

  alias Bittrex.{Currency, DepositAddress, Response}

  def call(%Currency{code: code}) do
    Request.new("/account/getdepositaddress", %{currency: code})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = parse_deposit_address(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_deposit_address(result) do
    %DepositAddress{
      currency: %Currency{
        code: result["Currency"],
      },
      address: result["Address"],
    }
  end
end
