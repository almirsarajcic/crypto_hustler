defmodule CryptoHustler.OrdersCsvParser do
  alias Bittrex.Parser.OrderParser

  def call(file_stream) do
    file_stream
    |> CSV.decode(headers: true)
    |> Stream.map(&parse_order/1)
    |> Enum.to_list()
  end

  defp parse_order(tuple) do
    {:ok, item} = tuple

    item = %{
      "OrderUuid" => item["Uuid"],
      "Exchange" => item["Exchange"],
      "TimeStamp" => reformat_datetime(item["TimeStamp"]),
      "OrderType" => item["OrderType"],
      "Limit" => convert_to_float(item["Limit"]),
      "Quantity" => convert_to_float(item["Quantity"]),
      "QuantityRemaining" => convert_to_float(item["QuantityRemaining"]),
      "Commission" => convert_to_float(item["Commission"]),
      "Price" => convert_to_float(item["Price"]),
      "PricePerUnit" => convert_to_float(item["PricePerUnit"]),
      "IsConditional" => convert_to_boolean(item["IsConditional"]),
      "Condition" => item["Condition"],
      "ConditionTarget" => convert_to_float(item["ConditionTarget"]),
      "ImmediateOrCancel" => convert_to_boolean(item["ImmediateOrCancel"]),
      "Closed" => reformat_datetime(item["Closed"]),
    }

    OrderParser.call(item)
  end

  def convert_to_float(""), do: nil
  def convert_to_float(string) do
    string = if string =~ "." do
      string
    else
      "#{string}.0"
    end

    String.to_float(string)
  end

  def convert_to_boolean(string) do
    if string == "True" do
      true
    else
      false
    end
  end

  defp reformat_datetime(string) do
    captures = Regex.named_captures(~r/(?<month>\d+)\/(?<day>\d+)\/(?<year>\d+) (?<hour>\d+):(?<minute>\d+):(?<second>\d+)(?: (?<period>[A-Z]+))?/, string)

    hour = if captures["period"] == "PM" && captures["hour"] != "12" do
      String.to_integer(captures["hour"]) + 12
    else
      String.to_integer(captures["hour"])
    end

    {:ok, datetime} = NaiveDateTime.from_erl({{String.to_integer(captures["year"]), String.to_integer(captures["month"]), String.to_integer(captures["day"])}, {hour, String.to_integer(captures["minute"]), String.to_integer(captures["second"])}})
    datetime
  end
end
