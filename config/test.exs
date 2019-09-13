import Config

config :crypto_hustler, :bittrex, client: Bittrex.Client.InMemoryClient

config :crypto_hustler, :coinmarketcap, client: Coinmarketcap.Client.InMemoryClient
