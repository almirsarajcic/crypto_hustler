defmodule Bittrex.Client.InMemoryClientTest do
  use ExUnit.Case, async: true

  alias Bittrex.Client.InMemoryClient

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "start_link/0 starts with no requests in the stack" do
    {:ok, pid} = GenServer.start_link(InMemoryClient, [])
    count = GenServer.call(pid, :all) |> Enum.count()
    assert count == 0
  end

  test "push a request to the stack" do
    InMemoryClient.push(%Bittrex.Request{})
    assert InMemoryClient.all() |> Enum.count() == 1
  end

  test "pop a request from the stack" do
    InMemoryClient.push(%Bittrex.Request{endpoint: "/public/getmarkets"})
    InMemoryClient.push(%Bittrex.Request{endpoint: "/public/getcurrencies"})
    assert InMemoryClient.all() |> Enum.count() == 2

    request = InMemoryClient.pop()
    assert request.endpoint == "/public/getcurrencies"
    assert InMemoryClient.all() |> Enum.count() == 1

    request = InMemoryClient.pop()
    assert request.endpoint == "/public/getmarkets"
    assert InMemoryClient.all() |> Enum.count() == 0
  end

  test "delete all requests from the stack" do
    InMemoryClient.push(%Bittrex.Request{})
    InMemoryClient.push(%Bittrex.Request{})
    assert InMemoryClient.all() |> Enum.count() == 2

    InMemoryClient.delete_all()
    assert InMemoryClient.all() |> Enum.count() == 0
  end
end
