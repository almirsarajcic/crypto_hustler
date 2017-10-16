defmodule Bittrex.Service.Account.WithdrawTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Currency, Withdrawal}
  alias Bittrex.Service.Account.Withdraw

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns Bittrex.Withdrawal struct" do
    InMemoryClient.push({:ok, %{
      "Uuid" => "68b5a16c-92de-11e3-ba3b-425861b86ab6"
    }})

    assert {:ok, %Withdrawal{
      uuid: "68b5a16c-92de-11e3-ba3b-425861b86ab6",
    }} = Withdraw.call(%Currency{code: "EAC"}, 20.40, "EAC_ADDRESS")
  end
end
