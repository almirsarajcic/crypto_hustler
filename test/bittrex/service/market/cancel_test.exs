defmodule Bittrex.Service.Market.CancelTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Data.Order
  alias Bittrex.{Request, Response}
  alias Bittrex.Service.Market.Cancel

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "cancels order" do
    InMemoryClient.push(%Response{status: :ok, body: nil})

    assert {:ok, nil} = Cancel.call(%Order{uuid: "614c34e4-8d71-11e3-94b5-425861b86ab6"})

    assert %Request{endpoint: "/market/cancel", params: params} = InMemoryClient.pop()
    assert params == %{uuid: "614c34e4-8d71-11e3-94b5-425861b86ab6"}
  end
end
