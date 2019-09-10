defmodule CryptoHustler.CoinsNumberCalculatorTest do
  use ExUnit.Case, async: true

  alias Bittrex.Data.{Balance, Currency}
  alias CryptoHustler.CoinsNumberCalculator

  test "calculates number of possible coins to buy from current holdings" do
    assert CoinsNumberCalculator.calculate([
      %Balance{
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
      }
    ], 10) == 6
  end
end
