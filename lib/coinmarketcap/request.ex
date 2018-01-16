defmodule Coinmarketcap.Request do
  defstruct [:endpoint, :headers, :params]

  def new(endpoint, params \\ %{}, headers \\ []) do
    %__MODULE__{endpoint: endpoint, headers: headers, params: params}
  end

  def set_endpoint(%__MODULE__{} = request, endpoint) do
    Map.put(request, :endpoint, endpoint)
  end

  def add_param(%__MODULE__{} = request, key, value) do
    params = Map.put(request.params, key, value)
    Map.put(request, :params, params)
  end

  def add_header(%__MODULE__{} = request, key, value) do
    headers = Keyword.merge(request.headers, [{key, value}])
    Map.put(request, :headers, headers)
  end
end
