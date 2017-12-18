defmodule CryptoHustler.BtcBalanceCalculatorTest do
  use ExUnit.Case

  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Ticker}
  alias CryptoHustler.{BtcBalance, BtcBalanceCalculator}

  test "calculates estimated BTC balance based on current prices" do
    balances = [%Balance{
      available: 0.00900003,
      balance: 0.01000003,
      crypto_address: "wAll3Taddr355",
      currency: %Currency{
        code: "BTC",
      },
      pending: 0.0,
    }, %Balance{
      available: 0.0,
      balance: 0.00779119,
      crypto_address: nil,
      currency: %Currency{
        code: "BTG",
      },
      pending: 0.0,
    }, %Balance{
      available: 76.42821529,
      balance: 76.42821529,
      crypto_address: nil,
      currency: %Currency{
        code: "NXT",
      },
      pending: 0.0,
    }, %Balance{
      available: 0.0,
      balance: 0.0,
      crypto_address: nil,
      currency: %Currency{
        code: "XRP",
      },
      pending: 0.0,
    }, %Balance{
      available: 0.46000299,
      balance: 0.46000299,
      crypto_address: "addr3ss",
      currency: %Currency{
        code: "USDT",
      },
      pending: 0.0,
    }]

    market_summaries = [%MarketSummary{
      base_volume: 1197.90220089,
      high: 0.0286999,
      low: 0.0266,
      market: %Market{
        name: "BTC-BTG",
        base_currency: %Currency{},
        created_at: ~N[2017-11-20 21:49:15.983],
        market_currency: %Currency{},
      },
      open_buy_orders: 1364,
      open_sell_orders: 16633,
      previous_day: 0.0285,
      ticker: %Ticker{
        ask: 0.02712209,
        bid: 0.02712196,
        last: 0.02712209,
      },
      volume: 43438.71861523,
    }, %MarketSummary{
      base_volume: 12668.63873056,
      high: 0.00004434,
      low: 0.00003237,
      market: %Market{
        name: "BTC-NXT",
        base_currency: %Currency{},
        created_at: ~N[2014-03-03 09:00:00],
        market_currency: %Currency{},
      },
      open_buy_orders: 3392,
      open_sell_orders: 6588,
      previous_day: 0.00003236,
      ticker: %Ticker{
        ask: 0.00004091,
        bid: 0.00004086,
        last: 0.00004086,
      },
      volume: 318114681.95070386,
    }, %MarketSummary{
      base_volume: 919.25522308,
      high: 0.00002236,
      low: 0.00002125,
      market: %Market{
        name: "BTC-XRP",
        base_currency: %Currency{},
        created_at: ~N[2014-12-22 19:30:27.45],
        market_currency: %Currency{},
      },
      open_buy_orders: 2162,
      open_sell_orders: 24666,
      previous_day: 0.00002180,
      ticker: %Ticker{
        ask: 0.00002165,
        bid: 0.00002161,
        last: 0.00002165,
      },
      volume: 42433675.0310635,
    }]

    assert %BtcBalance{
      real: 0.01000003,
      estimated: 0.01333420,
      available: 0.00900003,
    } = BtcBalanceCalculator.calculate(balances, market_summaries)
  end
end
