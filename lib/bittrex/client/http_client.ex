defmodule Bittrex.Client.HttpClient do
  @moduledoc """
  Implementation of Bittrex client for production
  """

  alias Bittrex.{Request, Response}

  @behaviour Bittrex.Client

  def send(request, config) do
    request
    |> add_api_key(config)
    |> add_nonce()
    |> add_base_url(config)
    |> add_params()
    |> add_api_sign(config)
    |> execute_request()
    |> process_response()
    |> format_response()
  end

  defp add_api_key(request, config) do
    Request.add_param(request, :apikey, config[:api_key])
  end

  defp add_nonce(request) do
    Request.add_param(request, :nonce, generate_nonce())
  end

  defp generate_nonce() do
    :os.system_time(:seconds)
  end

  defp add_base_url(request, config) do
    Request.set_endpoint(request, config[:base_url] <> request.endpoint)
  end

  defp add_params(request) do
    Request.set_endpoint(request, request.endpoint <> "?" <> URI.encode_query(request.params))
  end

  defp add_api_sign(request, config) do
    Request.add_header(request, :apisign, generate_api_sign(request.endpoint, config))
  end

  defp generate_api_sign(url, config) do
    :sha512
    |> :crypto.hmac(config[:api_secret], url)
    |> Base.encode16()
    |> String.downcase()
  end

  defp execute_request(request) do
    HTTPoison.get(request.endpoint, request.headers, [timeout: 30_000, recv_timeout: 30_000])
  end

  defp process_response({:ok, %{status_code: 200, body: body}} = _response) do
    decode_response(body)
  end
  defp process_response({:ok, %{status_code: 404}} = _response), do: {:error, "INVALID_ENDPOINT"}
  defp process_response({:error, reason}), do: {:error, reason}

  defp decode_response(body) do
    case Poison.decode(body) do
      {:ok, data} -> {:ok, data}
      _ -> {:error, "can't decode response body"}
    end
  end

  defp format_response({:ok, data}) do
    case data["success"] do
      true -> %Response{status: :ok, body: data["result"]}
      false -> %Response{status: :error, body: data["message"]}
    end
  end
  defp format_response({:error, reason}), do: %Response{status: :error, body: reason}
end
