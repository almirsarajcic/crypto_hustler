defmodule CryptoHustler.OrdersCsvParserTest do
  use ExUnit.Case, async: true

  alias Bittrex.Data.{Market, Order}
  alias CryptoHustler.OrdersCsvParser

  test "parses orders csv" do
    file_stream = "orders_csv_parser_test_data.csv"
    |> Path.expand(__DIR__)
    |> File.stream!()

    assert [%Order{
      uuid: "8981724f-c728-44f8-ab20-2759ba2abcd8",
      market: %Market{
        name: "BTC-VIB",
      },
      order_type: "LIMIT_SELL",
      quantity: 18.11756606,
      limit: 0.00004079,
      commission_paid: 0.00000184,
      rate: 0.00073901,
      opened_at: ~N[2017-12-25 01:06:25],
      closed_at: ~N[2018-01-04 08:19:52],
    }, %Order{
      uuid: "897874fa-a407-4612-bfbb-1ca4b6aef620",
      market: %Market{
        name: "BTC-ABY",
      },
      order_type: "LIMIT_BUY",
      quantity: 314.9826583,
      limit: 0.00000174,
      commission_paid: 0.00000137,
      rate: 0.00054806,
      opened_at: ~N[2017-12-31 12:57:08],
      closed_at: ~N[2017-12-31 12:57:09],
    }, %Order{
      uuid: "5dfc39c2-15c8-464c-84bd-17cbb09caa26",
      market: %Market{
        name: "BTC-EGC",
      },
      order_type: "LIMIT_BUY",
      quantity: 15.0,
      limit: 0.00004315,
      commission_paid: 0.00000161,
      rate: 0.00064725,
      opened_at: ~N[2017-12-31 15:39:48],
      closed_at: ~N[2017-12-31 15:42:47],
    }, %Order{
      uuid: "918cab98-0e18-4963-9e96-ecbffd0507ef",
      market: %Market{
        name: "BTC-LTC",
      },
      order_type: "LIMIT_BUY",
      quantity: 3.30998792,
      limit: 0.01646101,
      commission_paid: 0.00013621,
      rate: 0.05448574,
      opened_at: ~N[2018-01-03 09:03:45],
      closed_at: ~N[2018-01-03 09:03:49],
    }] = OrdersCsvParser.call(file_stream)
  end
end
