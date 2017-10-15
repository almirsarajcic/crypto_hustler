defmodule Bittrex.Order do
  defstruct [:uuid, :quantity, :rate, :market, :order_type, :quantity_remaining, :limit, :commission_paid, :price_per_unit, :opened_at, :closed_at, :cancel_initiated, :immediate_or_cancel, :conditional, :condition, :condition_target]

  def new(result) do
    %__MODULE__{
      uuid: result["uuid"],
    }
  end
end
