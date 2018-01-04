defmodule CryptoHustler.BaseCurrencyCalculatorTest do
  use ExUnit.Case, async: true

  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Ticker}
  alias CryptoHustler.{BaseCurrencyBalance, BaseCurrencyBalanceCalculator}

  # Balances:
  # BTC: 0.01000003
  # BTG: 0.00779119
  # NXT: 76.42821529
  # XRP: 0.0
  # USDT: 0.46000299

  # Rates:
  # USDT-XRP: 1.145
  # USDT-BTG: 276.0
  # USDT-BTC: 15732.0
  # BTC-XRP: 7.26e-5
  # BTC-NXT: 9.449e-5
  # BTC-BTG: 0.0174

  test "estimates BTC balance" do
    assert %BaseCurrencyBalance{
      real: 0.01000003,
      estimated: 0.01735730,
      available: 0.00800003,
      reserved: 0.1,
    } = BaseCurrencyBalanceCalculator.calculate("BTC", balances(), market_summaries(), 0.1)
  end

  test "estimates USDT balance" do
    assert %BaseCurrencyBalance{
      real: 0.46000299,
      estimated: 159.93084339,
      available: 0.44000299,
      reserved: 0.02,
    } = BaseCurrencyBalanceCalculator.calculate("USDT", balances(), market_summaries(), 0.02)
  end

  defp balances do
    [%Balance{
      available: 0.00900003,
      balance: 0.01000003,
      currency: %Currency{
        code: "BTC",
      },
      pending: 0.0,
    }, %Balance{
      available: 0.0,
      balance: 0.00779119,
      currency: %Currency{
        code: "BTG",
      },
      pending: 0.0,
    }, %Balance{
      available: 76.42821529,
      balance: 76.42821529,
      currency: %Currency{
        code: "NXT",
      },
      pending: 0.0,
    }, %Balance{
      available: 0.0,
      balance: 0.0,
      currency: %Currency{
        code: "XRP",
      },
      pending: 0.0,
    }, %Balance{
      available: 0.46000299,
      balance: 0.46000299,
      currency: %Currency{
        code: "USDT",
      },
      pending: 0.0,
    }]
  end

  defp market_summaries do
    [%MarketSummary{
      high: 1.18,
      low: 0.9731,
      market: %Market{
        active: true,
        base_currency: %Currency{
          active: true,
          code: "USDT",
        },
        market_currency: %Currency{
          active: true,
          code: "XRP",
        },
        name: "USDT-XRP",
      },
      previous_day: 0.997,
      ticker: %Ticker{
        ask: 1.145,
        bid: 1.13984454,
        last: 1.145,
      },
    }, %MarketSummary{
      high: 276.19165,
      low: 260.55000001,
      market: %Market{
        active: true,
        base_currency: %Currency{
          active: true,
          code: "USDT",
        },
        market_currency: %Currency{
          active: true,
          code: "BTG",
        },
        minimum_trade: 0.03757986,
        name: "USDT-BTG",
      },
      previous_day: 262.89999998,
      ticker: %Ticker{
        ask: 276.15000149,
        bid: 276.0,
        last: 276.0,
      },
    }, %MarketSummary{
      high: 16532.94334448,
      low: 15163.0,
      market: %Market{
        active: true,
        base_currency: %Currency{
          active: true,
          code: "USDT",
        },
        market_currency: %Currency{
          active: true,
          code: "BTC",
        },
        name: "USDT-BTC",
      },
      previous_day: 15176.0,
      ticker: %Ticker{
        ask: 15745.0,
        bid: 15732.0,
        last: 15732.0,
      },
    }, %MarketSummary{
      high: 7.677e-5,
      low: 6.1e-5,
      market: %Market{
        active: true,
        base_currency: %Currency{
          active: true,
          code: "BTC",
        },
        market_currency: %Currency{
          active: true,
          code: "XRP",
        },
        name: "BTC-XRP",
      },
      previous_day: 6.552e-5,
      ticker: %Ticker{
        ask: 7.27e-5,
        bid: 7.261e-5,
        last: 7.26e-5,
      },
    }, %MarketSummary{
      high: 1.0728e-4,
      low: 7.71e-5,
      market: %Market{
        active: true,
        base_currency: %Currency{
          active: true,
          code: "BTC",
        },
        market_currency: %Currency{
          active: true,
          code: "NXT",
        },
        name: "BTC-NXT"
      },
      previous_day: 1.0206e-4,
      ticker: %Ticker{
        ask: 9.449e-5,
        bid: 9.446e-5,
        last: 9.449e-5,
      },
    }, %MarketSummary{
      high: 0.01757877,
      low: 0.0165,
      market: %Market{
        active: true,
        base_currency: %Currency{
          active: true,
          code: "BTC",
        },
        market_currency: %Currency{
          active: true,
          code: "BTG",
        },
        name: "BTC-BTG",
      },
      previous_day: 0.01730028,
      ticker: %Ticker{
        ask: 0.017444,
        bid: 0.017401,
        last: 0.0174,
      },
    }]
  end
end
