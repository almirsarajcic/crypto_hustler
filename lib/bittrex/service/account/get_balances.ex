defmodule Bittrex.Service.Account.GetBalances do
  use Bittrex.Service

  alias Bittrex.{Balance, Currency}

  def call do
    Request.new("/account/getbalances")
    |> Client.send()
    |> format_response()
  end

  defp format_response({:ok, result}) do
    response = Enum.map(result, &parse_balance/1)
    {:ok, response}
  end
  defp format_response({:error, reason}), do: {:error, reason}

  defp parse_balance(result) do
    %Balance{
      currency: %Currency{
        code: result["Currency"],
      },
      balance: result["Balance"],
      available: result["Available"],
      pending: result["Pending"],
      crypto_address: result["CryptoAddress"],
      requested: result["Requested"],
      uuid: result["Uuid"],
    }
  end
end
