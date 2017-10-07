defmodule BittrexTest do
  use ExUnit.Case, async: true

  test "parses datetime" do
    assert Bittrex.parse_datetime("2017-10-07T19:00:00") == ~N[2017-10-07 19:00:00]
  end

  test "returns nil on invalid datetime format" do
    assert Bittrex.parse_datetime("19:00:00") == nil
  end
end
