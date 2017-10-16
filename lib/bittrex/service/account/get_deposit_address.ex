defmodule Bittrex.Service.Account.GetDepositAddress do
  use Bittrex.Service

  alias Bittrex.{Currency, DepositAddress}

  def call(%Currency{code: code}) do
    Request.new("/account/getdepositaddress", %{currency: code})
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = parse_deposit_address(result)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  defp parse_deposit_address(result) do
    %DepositAddress{
      currency: %Currency{
        code: result["Currency"],
      },
      address: result["Address"],
    }
  end
end
