defmodule Bittrex.Service.Account.GetOrder do
  use Bittrex.Service

  alias Bittrex.Data.Order
  alias Bittrex.Parser.OrderParser

  def call(%Order{uuid: uuid}) do
    Request.new("/account/getorder", %{uuid: uuid})
    |> Client.send()
    |> format_response()
  end

  defp format_response(%Response{status: :ok, body: result}) do
    response = OrderParser.call(result)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
