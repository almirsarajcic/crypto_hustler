defmodule Bittrex.Order do
  defstruct [:uuid, :quantity, :rate]

  def new(result) do
    %__MODULE__{
      uuid: result["uuid"],
    }
  end
end
