defmodule Bittrex do
  def parse_datetime(string) do
    case NaiveDateTime.from_iso8601(string) do
      {:ok, datetime} -> datetime
      _ -> nil
    end
  end
end
