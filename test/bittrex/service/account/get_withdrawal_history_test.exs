defmodule Bittrex.Service.Account.GetWithdrawalHistoryTest do
  use ExUnit.Case

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Currency, Withdrawal}
  alias Bittrex.Service.Account.GetWithdrawalHistory

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "returns list of Bittrex.Withdrawal structs" do
    InMemoryClient.push({:ok, [%{
      "PaymentUuid" => "b52c7a5c-90c6-4c6e-835c-e16df12708b1",
      "Currency" => "BTC",
      "Amount" => 17.00000000,
      "Address" => "1DeaaFBdbB5nrHj87x3NHS4onvw1GPNyAu",
      "Opened" => "2014-07-09T04:24:47.217",
      "Authorized" => true,
      "PendingPayment" => false,
      "TxCost" => 0.00020000,
      "TxId" => nil,
      "Canceled" => true,
      "InvalidAddress" => false
    }, %{
      "PaymentUuid" => "f293da98-788c-4188-a8f9-8ec2c33fdfcf",
      "Currency" => "XC",
      "Amount" => 7513.75121715,
      "Address" => "XVnSMgAd7EonF2Dgc4c9K14L12RBaW5S5J",
      "Opened" => "2014-07-08T23:13:31.83",
      "Authorized" => true,
      "PendingPayment" => false,
      "TxCost" => 0.00002000,
      "TxId" => "b4a575c2a71c7e56d02ab8e26bb1ef0a2f6cf2094f6ca2116476a569c1e84f6e",
      "Canceled" => false,
      "InvalidAddress" => false
    }]})

    assert {:ok, [%Withdrawal{
      uuid: "b52c7a5c-90c6-4c6e-835c-e16df12708b1",
      currency: %Currency{
        code: "BTC",
      },
      amount: 17.00000000,
      address: "1DeaaFBdbB5nrHj87x3NHS4onvw1GPNyAu",
      opened_at: ~N[2014-07-09 04:24:47.217],
      authorized: true,
      pending: false,
      transaction_cost: 0.00020000,
      transaction_id: nil,
      canceled: true,
      invalid_address: false,
    }, %Withdrawal{
      uuid: "f293da98-788c-4188-a8f9-8ec2c33fdfcf",
      currency: %Currency{
        code: "XC",
      },
      amount: 7513.75121715,
      address: "XVnSMgAd7EonF2Dgc4c9K14L12RBaW5S5J",
      opened_at: ~N[2014-07-08 23:13:31.83],
      authorized: true,
      pending: false,
      transaction_cost: 0.00002000,
      transaction_id: "b4a575c2a71c7e56d02ab8e26bb1ef0a2f6cf2094f6ca2116476a569c1e84f6e",
      canceled: false,
      invalid_address: false,
    }]} = GetWithdrawalHistory.call(%Currency{code: "BTC"})
  end
end
