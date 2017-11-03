defmodule Bittrex.Parser.OrderParser do
  alias Bittrex.Data.Order
  alias Bittrex.Parser.MarketParser

  def call(item) do
    %Order{
      uuid: item["OrderUuid"] || item["uuid"],
      account_id: item["AccountId"],
      market: MarketParser.call(item),
      opened_at: Bittrex.parse_datetime(item["Opened"] || item["TimeStamp"]),
      closed_at: Bittrex.parse_datetime(item["Closed"]),
      order_type: item["OrderType"] || item["Type"],
      limit: item["Limit"],
      quantity: item["Quantity"],
      quantity_remaining: item["QuantityRemaining"],
      reserved: item["Reserved"],
      reserve_remaining: item["ReserveRemaining"],
      commision_reserved: item["CommissionReserved"],
      commision_reserve_remaining: item["CommissionReserveRemaining"],
      commission_paid: item["CommissionPaid"] || item["Commission"],
      rate: item["Price"] || item["Rate"],
      price_per_unit: item["PricePerUnit"],
      conditional: item["IsConditional"],
      condition: item["Condition"],
      condition_target: item["ConditionTarget"],
      immediate_or_cancel: item["ImmediateOrCancel"],
      open: item["IsOpen"],
      sentinel: item["Sentinel"],
      cancel_initiated: item["CancelInitiated"],
    }
  end
end
