defmodule Bittrex.Client.InMemoryClientTest do
  use ExUnit.Case, async: true

  alias Bittrex.Client.InMemoryClient
  alias Bittrex.Response

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
    InMemoryClient.push(%Response{})
    assert InMemoryClient.all() |> Enum.count() == 1
  end

  test "pop a response from the stack" do
    InMemoryClient.push(%Response{status: :error})
    InMemoryClient.push(%Response{status: :ok})
    assert InMemoryClient.all() |> Enum.count() == 2

    assert %Response{status: :ok} = InMemoryClient.pop()
    assert InMemoryClient.all() |> Enum.count() == 1

    assert %Response{status: :error} = InMemoryClient.pop()
    assert InMemoryClient.all() |> Enum.count() == 0
  end

  test "delete all responses from the stack" do
    InMemoryClient.push(%Response{})
    InMemoryClient.push(%Response{})
    assert InMemoryClient.all() |> Enum.count() == 2

    InMemoryClient.delete_all()
    assert InMemoryClient.all() |> Enum.count() == 0
  end
end
