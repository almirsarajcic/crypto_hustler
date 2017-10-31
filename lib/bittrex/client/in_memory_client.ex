defmodule Bittrex.Client.InMemoryClient do
  @moduledoc """
  Implementation of Bittrex client for testing
  """

  use GenServer

  @behaviour Bittrex.Client

  def send(_request, _config) do
    pop()
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def stop() do
    GenServer.stop(__MODULE__)
  end

  def push(response) do
    GenServer.call(__MODULE__, {:push, response})
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

  def handle_call({:push, response}, _from, responses) do
    {:reply, response, [response] ++ responses}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end
  def handle_call(:pop, _from, [head|tail]) do
    {:reply, head, tail}
  end

  def handle_call(:all, _from, responses) do
    {:reply, responses, responses}
  end

  def handle_call(:delete_all, _from, _responses) do
    {:reply, :ok, []}
  end
end
