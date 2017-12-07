defmodule CryptoHustler.DataCombiner do
  alias Bittrex.Data.{Currency, Market}

  def combine_currencies_with_markets(currencies, markets, combined_markets \\ [])
  def combine_currencies_with_markets(_, [], combined_markets), do: combined_markets
  def combine_currencies_with_markets(currencies, [head|tail], combined_markets) do
    market = Map.put(head, :base_currency, find_currency(head.base_currency.code, currencies))
    market = Map.put(market, :market_currency, find_currency(head.market_currency.code, currencies))

    combine_currencies_with_markets(currencies, tail, [market|combined_markets])
  end

  def combine_markets_with_market_summaries(markets, market_summaries, combined_market_summaries \\ [])
  def combine_markets_with_market_summaries(_, [], combined_market_summaries), do: combined_market_summaries
  def combine_markets_with_market_summaries(markets, [head|tail], combined_market_summaries) do
    market_summary = Map.put(head, :market, find_market(head.market.name, markets))

    combine_markets_with_market_summaries(markets, tail, [market_summary|combined_market_summaries])
  end

  defp find_currency(code, [head|tail]) do
    case head do
      %Currency{code: ^code} ->
        head
      _ ->
        find_currency(code, tail)
    end
  end

  defp find_market(name, [head|tail]) do
    case head do
      %Market{name: ^name} ->
        head
      _ ->
        find_market(name, tail)
    end
  end
end
