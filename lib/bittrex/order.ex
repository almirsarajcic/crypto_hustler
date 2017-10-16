defmodule Bittrex.Order do
  defstruct [:uuid, :account_id, :market,  :order_type, :quantity, :quantity_remaining, :limit, :reserved, :reserve_remaining, :commision, :commision_reserved, :commision_reserve_remaining, :commission_paid, :rate, :price_per_unit, :opened_at, :closed_at, :open, :sentinel, :cancel_initiated, :immediate_or_cancel, :conditional, :condition, :condition_target]

  def new(result) do
    %__MODULE__{
      uuid: result["uuid"],
    }
  end
end
