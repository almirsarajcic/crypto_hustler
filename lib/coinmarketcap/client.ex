defmodule Coinmarketcap.Client do
  @moduledoc """
  Specification of Bittrex client
  """

  @type request :: Coinmarketcap.Request.t
  @type config :: Keyword.t
  @type response :: Coinmarketcap.Response.t

  @callback send(request, config) :: response

  @default_client Coinmarketcap.Client.HttpClient

  def send(request) do
    config = Application.get_env(:crypto_hustler, :coinmarketcap)
    client = config[:client] || @default_client
    client.send(request, config)
  end
end
