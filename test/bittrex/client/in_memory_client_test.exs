defmodule Bittrex.Client.InMemoryClientTest do
  use ExUnit.Case, async: true

  alias Bittrex.Client.InMemoryClient

  setup do
    InMemoryClient.delete_all()
    :ok
  end

  test "start_link/0 starts with no responses in the stack" do
    {:ok, pid} = GenServer.start_link(InMemoryClient, [])
    count = GenServer.call(pid, :all) |> Enum.count()
    assert count == 0
  end

  test "push a response to the stack" do
    InMemoryClient.push({:ok, nil})
    assert InMemoryClient.all() |> Enum.count() == 1
  end

  test "pop a response from the stack" do
    InMemoryClient.push({:error, 1})
    InMemoryClient.push({:ok, 2})
    assert InMemoryClient.all() |> Enum.count() == 2

    assert {:ok, 2} = InMemoryClient.pop()
    assert InMemoryClient.all() |> Enum.count() == 1

    assert {:error, 1} = InMemoryClient.pop()
    assert InMemoryClient.all() |> Enum.count() == 0
  end

  test "delete all responses from the stack" do
    InMemoryClient.push({:ok, nil})
    InMemoryClient.push({:error, nil})
    assert InMemoryClient.all() |> Enum.count() == 2

    InMemoryClient.delete_all()
    assert InMemoryClient.all() |> Enum.count() == 0
  end
end
