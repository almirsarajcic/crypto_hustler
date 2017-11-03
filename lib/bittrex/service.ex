defmodule Bittrex.Service do
  defmacro __using__(_) do
    quote do
      alias Bittrex.{Client, Request, Response}
    end
  end
end
