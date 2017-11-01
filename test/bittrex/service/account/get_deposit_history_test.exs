defmodule Bittrex.Service.Account.GetDepositHistoryTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Currency, Deposit, Request, Response}
  alias Bittrex.Service.Account.GetDepositHistory

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "sends request to /account/getdeposithistory and returns list of Bittrex.Deposit structs" do
    InMemoryClient.push(%Response{status: :ok, body: [%{
      "Amount" => 0.16240000,
      "Confirmations" => 2,
      "CryptoAddress" => "2L8i6hsgjfaugcpH1bCzE7LMUWGBMJFUpM",
      "Currency" => "BTC",
      "Id" => 3239,
      "LastUpdated" => "2017-09-23T14:50:00.797",
      "TxId" => "5deff882b647a3e5b754c41czdfc7f663b0a223bf879bdd24e077ad65b28a5af"
    }]})

    assert {:ok, [%Deposit{
      id: 3239,
      currency: %Currency{
        code: "BTC",
      },
      amount: 0.16240000,
      address: "2L8i6hsgjfaugcpH1bCzE7LMUWGBMJFUpM",
      updated_at: ~N[2017-09-23 14:50:00.797],
      transaction_id: "5deff882b647a3e5b754c41czdfc7f663b0a223bf879bdd24e077ad65b28a5af",
    }]} = GetDepositHistory.call(%Currency{code: "BTC"})

    # TODO check that GetDepositHistory.call() sends requests without params
    assert %Request{endpoint: "/account/getdeposithistory", params: params} = InMemoryClient.pop()
    assert params == %{currency: "BTC"}
  end
end
