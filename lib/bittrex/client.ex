defmodule Bittrex.Client do
  @moduledoc """
  Specification of Bittrex client
  """

  @type request :: Bittrex.Request.t
  @type config :: Keyword.t
  @type response :: {atom, any}

  @callback send(request, config) :: response

  @default_client Bittrex.Client.HttpClient

  def send(request) do
    config = Application.get_env(:crypto_hustler, :bittrex)
    client = config[:client] || @default_client
    client.send(request, config)
  end
end
