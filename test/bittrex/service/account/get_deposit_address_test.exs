defmodule Bittrex.Service.Account.GetDepositAddressTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Data.{Currency, DepositAddress}
  alias Bittrex.{Request, Response}
  alias Bittrex.Service.Account.GetDepositAddress

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /account/getdepositaddress and returns Bittrex.DepositAddress struct" do
    InMemoryClient.push(%Response{status: :ok, body: %{
      "Currency" => "VTC",
      "Address" => "Vy5SKeKGXUHKS2WVpJ76HYuKAu3URastUo",
    }})

    assert {:ok, %DepositAddress{
      currency: %Currency{
        code: "VTC",
      },
      address: "Vy5SKeKGXUHKS2WVpJ76HYuKAu3URastUo",
    }} = GetDepositAddress.call(%Currency{code: "VTC"})

    assert %Request{endpoint: "/account/getdepositaddress", params: params} = InMemoryClient.pop()
    assert params == %{currency: "VTC"}
  end
end
