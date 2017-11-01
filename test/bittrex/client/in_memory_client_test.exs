defmodule Bittrex.Client.InMemoryClientTest do
  use ExUnit.Case, async: true

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.{Request, Response}

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "start_link/0 starts with no items in the stack" do
    {:ok, pid} = GenServer.start_link(InMemoryClient, [])
    count = GenServer.call(pid, :all) |> Enum.count()
    assert count == 0
  end

  test "push an item to the stack" do
    InMemoryClient.push(%Request{})
    assert InMemoryClient.all() |> Enum.count() == 1
  end

  test "pop an item from the stack" do
    InMemoryClient.push(%Request{})
    InMemoryClient.push(%Response{status: :ok})
    assert InMemoryClient.all() |> Enum.count() == 2

    assert %Response{status: :ok} = InMemoryClient.pop()
    assert InMemoryClient.all() |> Enum.count() == 1

    assert %Request{} = InMemoryClient.pop()
    assert InMemoryClient.all() |> Enum.count() == 0
  end

  test "pop doesn't fail when there are no items in the stack" do
    assert InMemoryClient.pop() == nil
  end

  test "delete all items from the stack" do
    InMemoryClient.push(%Request{})
    InMemoryClient.push(%Response{})
    assert InMemoryClient.all() |> Enum.count() == 2

    InMemoryClient.delete_all()
    assert InMemoryClient.all() |> Enum.count() == 0
  end
end
