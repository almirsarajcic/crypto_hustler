defmodule CryptoHustler.BaseCurrencyBalanceCalculator do
  alias Bittrex.Data.{Balance, Currency, Market, MarketSummary, Ticker}
  alias CryptoHustler.BaseCurrencyBalance

  def calculate(base_currency, balances, market_summaries) do
    base_currency_balance = get_base_currency_balance(base_currency, balances)
    estimated = estimated_base_currency_balance(base_currency, market_summaries, balances)

    %BaseCurrencyBalance{
      real: base_currency_balance.balance,
      estimated: Float.round(estimated, 8),
      available: base_currency_balance.available,
    }
  end

  defp get_base_currency_balance(base_currency, []), do: %Balance{currency: %Currency{code: base_currency}, balance: 0.0, available: 0.0, pending: 0.0}
  defp get_base_currency_balance(base_currency, [head|tail]) do
    case head do
      %Balance{currency: %Currency{code: ^base_currency}} ->
        head
      _ ->
        get_base_currency_balance(base_currency, tail)
    end
  end

  defp estimated_base_currency_balance(_, _, _, balance \\ 0.0)
  defp estimated_base_currency_balance(_, _, [], balance), do: balance
  defp estimated_base_currency_balance(base_currency_code, market_summaries, [head|tail], balance) do
    balance = case head.currency do
      %Currency{code: ^base_currency_code} ->
        balance + head.balance
      %Currency{code: market_currency_code} ->
        price = get_currency_price(base_currency_code, market_currency_code, market_summaries)
        balance + head.balance * price
    end

    estimated_base_currency_balance(base_currency_code, market_summaries, tail, balance)
  end

  defp get_currency_price(_, _, []), do: 0
  defp get_currency_price(base_currency_code, market_currency_code, [head|tail]) do
    case head do
      %MarketSummary{market: %Market{base_currency: %Currency{code: ^base_currency_code}, market_currency: %Currency{code: ^market_currency_code}}, ticker: %Ticker{last: price}} ->
        price
      _ ->
        get_currency_price(base_currency_code, market_currency_code, tail)
    end
  end
end
