import Config

config :crypto_hustler, :bittrex,
  client: Bittrex.Client.HttpClient,
  base_url: "https://bittrex.com/api/v1.1",
  api_key: System.fetch_env!("BITTREX_API_KEY"),
  api_secret: System.fetch_env!("BITTREX_API_SECRET")

config :crypto_hustler, :bot,
  base_currency: System.fetch_env!("BOT_BASE_CURRENCY"),
  number_of_coins: System.fetch_env!("BOT_NUMBER_OF_COINS"),
  profit_percentage: System.fetch_env!("BOT_PROFIT_PERCENTAGE"),
  halt: System.fetch_env("BOT_HALT"),
  reserved: System.fetch_env!("BOT_RESERVED")
