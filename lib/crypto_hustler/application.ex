defmodule CryptoHustler.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Bittrex.Client.InMemoryClient, []),
      worker(Coinmarketcap.Client.InMemoryClient, []),
      worker(CryptoHustler.Bot, []),
    ]

    opts = [strategy: :one_for_one, name: CryptoHustler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
