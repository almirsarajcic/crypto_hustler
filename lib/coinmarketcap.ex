defmodule Coinmarketcap do
  def calculate_percentage(nil), do: nil
  def calculate_percentage(string) when is_binary(string), do: calculate_percentage(extract_float(string))
  def calculate_percentage(number), do: Float.round(number / 100, 4)

  def extract_float(nil), do: nil
  def extract_float(string) do
    string = if Regex.match?(~r/\./, string) do
      string
    else
      string <> ".0"
    end

    String.to_float(string)
  end

  def parse_datetime(nil), do: nil
  def parse_datetime(string) when is_binary(string), do: parse_datetime(String.to_integer(string))
  def parse_datetime(integer), do: NaiveDateTime.add(~N[1970-01-01 00:00:00], integer)
end
