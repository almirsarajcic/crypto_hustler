defmodule Bittrex.Service.Account.GetOrderHistory do
  use Bittrex.Service

  alias Bittrex.Data.Market
  alias Bittrex.Parser.OrderParser

  def call(market = %Market{} \\ %Market{}) do
    Request.new("/account/getorderhistory", get_params(market))
    |> Client.send()
    |> format_response()
  end

  # When sending %{market: nil} Bittrex returns "INVALID_MARKET" error,
  # unlike with Bittrex.Service.Market.GetOpenOrders
  def get_params(%Market{name: nil}), do: %{}
  def get_params(%Market{name: name}), do: %{market: name}

  defp format_response(%Response{status: :ok, body: result}) do
    response = Enum.map(result, &OrderParser.call/1)
    {:ok, response}
  end
  defp format_response(%Response{status: :error, body: reason}), do: {:error, reason}
end
