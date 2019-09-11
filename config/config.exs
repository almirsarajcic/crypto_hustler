import Config

config :crypto_hustler, :bittrex, client: Bittrex.Client.HttpClient

config :crypto_hustler, :coinmarketcap, client: Coinmarketcap.Client.HttpClient,
  base_url: "https://api.coinmarketcap.com/v1"

import_config "#{Mix.env()}.exs"
