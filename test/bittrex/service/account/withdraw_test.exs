defmodule Bittrex.Service.Account.WithdrawTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Currency, Request, Response, Withdrawal}
  alias Bittrex.Service.Account.Withdraw

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /account/withdraw and returns Bittrex.Withdrawal struct" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "Uuid" => "68b5a16c-92de-11e3-ba3b-425861b86ab6"
    }})

    assert {:ok, %Withdrawal{
      uuid: "68b5a16c-92de-11e3-ba3b-425861b86ab6",
    }} = Withdraw.call(%Currency{code: "EAC"}, 20.40, "EAC_ADDRESS")

    assert %Request{endpoint: "/account/withdraw", params: params} = InMemoryClient.pop()
    assert params == %{currency: "EAC", quantity: 20.40, address: "EAC_ADDRESS"}
  end
end
