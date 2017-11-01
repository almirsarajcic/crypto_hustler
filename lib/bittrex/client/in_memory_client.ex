defmodule Bittrex.Client.InMemoryClient do
  @moduledoc """
  Implementation of Bittrex client for testing
  """

  use GenServer

  @behaviour Bittrex.Client

  def send(request, _config) do
    response = pop()
    push(request)
    response
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def stop() do
    GenServer.stop(__MODULE__)
  end

  def push(item) do
    GenServer.call(__MODULE__, {:push, item})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def delete_all() do
    GenServer.call(__MODULE__, :delete_all)
  end

  # Callbacks

  def init(_args) do
    {:ok, []}
  end

  def handle_call({:push, item}, _from, stack) do
    {:reply, item, [item] ++ stack}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end
  def handle_call(:pop, _from, [head|tail]) do
    {:reply, head, tail}
  end

  def handle_call(:all, _from, stack) do
    {:reply, stack, stack}
  end

  def handle_call(:delete_all, _from, _stack) do
    {:reply, :ok, []}
  end
end
