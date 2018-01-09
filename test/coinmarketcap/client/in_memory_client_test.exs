defmodule Coinmarketcap.Client.InMemoryClientTest do
  use ExUnit.Case, async: true

  alias Coinmarketcap.Client.InMemoryClient
  alias Coinmarketcap.{Request, Response}

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "start_link/0 starts with no items in the stacks" do
    {:ok, pid} = GenServer.start_link(InMemoryClient, [])
    assert GenServer.call(pid, :requests) |> Enum.count() == 0
    assert GenServer.call(pid, :responses) |> Enum.count() == 0
  end

  test "push request to the stack" do
    InMemoryClient.push(%Request{})
    assert InMemoryClient.requests() |> Enum.count() == 1
  end

  test "push response to the stack" do
    InMemoryClient.push(%Response{})
    assert InMemoryClient.responses() |> Enum.count() == 1
  end

  test "pop response from the stack" do
    InMemoryClient.push(%Response{status: :ok})
    assert InMemoryClient.responses() |> Enum.count() == 1

    assert %Response{status: :ok} = InMemoryClient.pop_response()
    assert InMemoryClient.responses() |> Enum.count() == 0
  end

  test "pop_response doesn't fail when there are no responses in the stack" do
    assert InMemoryClient.pop_response() == nil
  end

  test "delete all items from the stacks" do
    InMemoryClient.push(%Request{})
    InMemoryClient.push(%Response{})
    assert InMemoryClient.requests() |> Enum.count() == 1
    assert InMemoryClient.responses() |> Enum.count() == 1

    InMemoryClient.delete_all()
    assert InMemoryClient.requests() |> Enum.count() == 0
    assert InMemoryClient.responses() |> Enum.count() == 0
  end
end
