defmodule Bittrex.Client.HttpClient do
  @moduledoc """
  Implementation of Bittrex client for production
  """

  @behaviour Bittrex.Client

  def send(request, config) do
    params = request.params
    |> add_api_key(config)
    |> add_nonce()

    url = request.endpoint
    |> add_base_url(config)
    |> add_params(params)

    api_sign = url
    |> generate_api_sign(config)

    case HTTPoison.get url, [apisign: api_sign] do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %Bittrex.Response{status: :ok, body: body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %Bittrex.Response{status: :not_found, body: "Not Found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        %Bittrex.Response{status: :error, body: reason}
    end
  end

  defp add_api_key(params, config) do
    Map.put(params, :apikey, config[:api_key])
  end

  defp add_nonce(params) do
    Map.put(params, :nonce, generate_nonce())
  end

  defp add_base_url(endpoint, config) do
    config[:base_url] <> endpoint
  end

  defp add_params(url, params) do
    url <> "?" <> URI.encode_query(params)
  end

  defp generate_nonce() do
    :os.system_time(:seconds)
  end

  defp generate_api_sign(url, config) do
    :sha512
    |> :crypto.hmac(config[:api_secret], url)
    |> Base.encode16()
    |> String.downcase()
  end
end
