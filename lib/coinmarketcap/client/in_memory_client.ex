defmodule Coinmarketcap.Client.InMemoryClient do
  @moduledoc """
  Implementation of Coinmarketcap client for testing
  """

  use GenServer

  alias Coinmarketcap.{Request, Response}

  @behaviour Coinmarketcap.Client

  def send(request, _config) do
    push(request)
    pop_response()
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

  def pop_response() do
    GenServer.call(__MODULE__, :pop_response)
  end

  def requests() do
    GenServer.call(__MODULE__, :requests)
  end

  def responses() do
    GenServer.call(__MODULE__, :responses)
  end

  def delete_all() do
    GenServer.call(__MODULE__, :delete_all)
  end

  # Callbacks

  def init(_args) do
    {:ok, {[], []}}
  end

  def handle_call({:push, %Request{} = request}, _from, {requests, responses}) do
    {:reply, request, {[request] ++ requests, responses}}
  end
  def handle_call({:push, %Response{} = response}, _from, {requests, responses}) do
    {:reply, response, {requests, [response] ++ responses}}
  end

  def handle_call(:pop_response, _from, {_, []} = tuple) do
    {:reply, nil, tuple}
  end
  def handle_call(:pop_response, _from, {requests, [head|tail]}) do
    {:reply, head, {requests, tail}}
  end

  def handle_call(:requests, _from, {requests, _} = tuple) do
    {:reply, requests, tuple}
  end

  def handle_call(:responses, _from, {_, responses} = tuple) do
    {:reply, responses, tuple}
  end

  def handle_call(:delete_all, _from, _stack) do
    {:reply, :ok, {[], []}}
  end
end
