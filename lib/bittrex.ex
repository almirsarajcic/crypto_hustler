defmodule Bittrex do
  def parse_datetime(nil), do: nil
  def parse_datetime(string) when is_binary(string) do
    case NaiveDateTime.from_iso8601(string) do
      {:ok, datetime} -> datetime
      _ -> nil
    end
  end
  def parse_datetime(datetime), do: datetime
end
