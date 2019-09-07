defmodule Coinmarketcap.Client.HttpClient do
  @moduledoc """
  Implementation of Coinmarketcap client for production
  """

  alias Coinmarketcap.{Request, Response}

  @behaviour Coinmarketcap.Client

  def send(request, config) do
    request
    |> add_base_url(config)
    |> add_params()
    |> execute_request()
    |> process_response()
    |> format_response()
  end

  defp add_base_url(request, config) do
    Request.set_endpoint(request, config[:base_url] <> request.endpoint)
  end

  defp add_params(request) do
    Request.set_endpoint(request, request.endpoint <> "?" <> URI.encode_query(request.params))
  end

  defp execute_request(request) do
    HTTPoison.get(request.endpoint, request.headers, [timeout: 30_000, recv_timeout: 30_000])
  end

  defp process_response({:ok, %{status_code: 200, body: body}} = _response) do
    decode_response(body)
  end
  defp process_response({:ok, %{status_code: 404}} = _response), do: {:error, "not found"}
  defp process_response({:error, reason}), do: {:error, reason}

  defp decode_response(body) do
    case Poison.decode(body) do
      {:ok, data} -> {:ok, data}
      _ -> {:error, "can't decode response body"}
    end
  end

  defp format_response({:ok, data}), do: %Response{status: :ok, body: data}
  defp format_response({:error, reason}), do: %Response{status: :error, body: reason}
end
