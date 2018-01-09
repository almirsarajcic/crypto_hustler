use Mix.Config

config :crypto_hustler, :bittrex,
  client: Bittrex.Client.HttpClient,
  base_url: "https://bittrex.com/api/v1.1",
  api_key: "${BITTREX_API_KEY}",
  api_secret: "${BITTREX_API_SECRET}"

config :crypto_hustler, :bot,
  base_currency: "${BOT_BASE_CURRENCY}",
  number_of_coins: "${BOT_NUMBER_OF_COINS}",
  profit_percentage: "${BOT_PROFIT_PERCENTAGE}",
  halt: "${BOT_HALT}",
  reserved: "${BOT_RESERVED}"
