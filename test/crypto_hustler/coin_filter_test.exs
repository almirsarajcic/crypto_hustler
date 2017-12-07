defmodule CryptoHustler.CoinFinderTest do
  use ExUnit.Case

  alias Bittrex.Data.{Currency, Market, Order}
  alias CryptoHustler.CoinFilter

  test "finds new coins to buy" do
    currencies = [%Currency{
      active: true,
      base_address: "1N52wHoVR79PMDishab2XmRHsbekCdGquK",
      code: "BTC",
      coin_type: "BITCOIN",
      minimum_confirmation: 2,
      name: "Bitcoin",
      transaction_fee: 0.001,
    }, %Currency{
      active: true,
      base_address: "LhyLNfBkoKshT7R8Pce6vkB9T2cP2o84hx",
      code: "LTC",
      coin_type: "BITCOIN",
      minimum_confirmation: 6,
      name: "Litecoin",
      transaction_fee: 0.01,
    }, %Currency{
      active: true,
      base_address: "NXT-97H4-KRWL-A53G-7GVRG",
      code: "NXT",
      coin_type: "NXT",
      minimum_confirmation: 8,
      name: "NXT",
      transaction_fee: 2.0,
    }, %Currency{
      active: true,
      base_address: nil,
      code: "BLK",
      coin_type: "BITCOIN",
      minimum_confirmation: 6,
      name: "BlackCoin",
      transaction_fee: 0.02,
    }, %Currency{
      active: false,
      base_address: nil,
      code: "OC",
      coin_type: "BITCOIN",
      minimum_confirmation: 20,
      name: "OrangeCoin",
      transaction_fee: 0.2
    }]
    order_history = [%Order{
      account_id: nil,
      cancel_initiated: nil,
      closed_at: ~N[2017-12-04 08:46:55.36],
      commision: nil,
      commision_reserve_remaining: nil,
      commision_reserved: nil,
      commission_paid: 8.12e-6,
      condition: "NONE",
      condition_target: nil,
      conditional: false,
      immediate_or_cancel: false,
      limit: 4.25e-5,
      market: %Market{
        active: nil,
        base_currency: %Currency{},
        created_at: nil,
        market_currency: %Currency{},
        minimum_trade: nil,
        name: "BTC-NXT"
      },
      open: nil,
      opened_at: ~N[2017-12-04 08:46:42.907],
      order_type: "LIMIT_BUY",
      price_per_unit: 4.249e-5,
      quantity: 76.42821529,
      quantity_remaining: 0.0,
      rate: 0.00324819,
      reserve_remaining: nil,
      reserved: nil,
      sentinel: nil,
      uuid: "0b3032ea-8776-4127-9971-d37ea70ea4d2"
    }, %Order{
      account_id: nil,
      cancel_initiated: nil,
      closed_at: ~N[2017-12-04 08:09:29.487],
      commision: nil,
      commision_reserve_remaining: nil,
      commision_reserved: nil,
      commission_paid: 8.16e-6,
      condition: "NONE",
      condition_target: nil,
      conditional: false,
      immediate_or_cancel: false,
      limit: 2.15e-5,
      market: %Market{
        active: nil,
        base_currency: %Currency{},
        created_at: nil,
        market_currency: %Currency{},
        minimum_trade: nil,
        name: "BTC-XRP"
      },
      open: nil,
      opened_at: ~N[2017-12-04 08:04:23.947],
      order_type: "LIMIT_SELL",
      price_per_unit: 2.149e-5,
      quantity: 151.836125,
      quantity_remaining: 0.0,
      rate: 0.00326447,
      reserve_remaining: nil,
      reserved: nil,
      sentinel: nil,
      uuid: "77c925ad-a5ca-4033-bd8f-d8983dee181c"
    }, %Order{
      account_id: nil,
      cancel_initiated: nil,
      closed_at: ~N[2017-11-25 20:49:12.44],
      commision: nil,
      commision_reserve_remaining: nil,
      commision_reserved: nil,
      commission_paid: 1.093e-5,
      condition: "NONE",
      condition_target: nil,
      conditional: false,
      immediate_or_cancel: false,
      limit: 2.88e-5,
      market: %Market{
        active: nil,
        base_currency: %Currency{},
        created_at: nil,
        market_currency: %Currency{},
        minimum_trade: nil,
        name: "BTC-XRP"
      },
      open: nil,
      opened_at: ~N[2017-11-25 20:43:05.743],
      order_type: "LIMIT_BUY",
      price_per_unit: 2.879e-5,
      quantity: 151.836125,
      quantity_remaining: 0.0,
      rate: 0.00437288,
      reserve_remaining: nil,
      reserved: nil,
      sentinel: nil,
      uuid: "0060b7a0-03e6-48f1-976d-b0a67ee53c91"
    }]

    assert [%Currency{
      active: true,
      base_address: nil,
      code: "BLK",
      coin_type: "BITCOIN",
      minimum_confirmation: 6,
      name: "BlackCoin",
      transaction_fee: 0.02,
    }, %Currency{
      active: true,
      base_address: "LhyLNfBkoKshT7R8Pce6vkB9T2cP2o84hx",
      code: "LTC",
      coin_type: "BITCOIN",
      minimum_confirmation: 6,
      name: "Litecoin",
      transaction_fee: 0.01,
    }] = CoinFilter.find_new_currencies(order_history, currencies)
  end
end
