use Mix.Config

config :crypto_hustler, :bittrex,
  client: Bittrex.Client.HttpClient,
  base_url: "https://bittrex.com/api/v1.1",
  api_key: "${BITTREX_API_KEY}",
  api_secret: "${BITTREX_API_SECRET}",
  base_currency: "${BITTREX_BASE_CURRENCY}",
  number_of_coins: "${BITTREX_NUMBER_OF_COINS}"
