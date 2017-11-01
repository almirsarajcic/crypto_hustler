defmodule Bittrex.Service.Public.GetCurrencies do
  use Bittrex.Service

  alias Bittrex.Data.Currency

  def call do
    Request.new("/public/getcurrencies")
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &parse_currency/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}

  defp parse_currency(result) do
    %Currency{
      code: result["Currency"],
      name: result["CurrencyLong"],
      active: result["IsActive"],
      transaction_fee: result["TxFee"],
      minimum_confirmation: result["MinConfirmation"],
      coin_type: result["CoinType"],
      base_address: result["BaseAddress"],
    }
  end
end
