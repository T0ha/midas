defmodule Portfolio.BalancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Balances` context.
  """

  @doc """
  Generate a balance.
  """
  def balance_fixture(attrs \\ %{}) do
    {:ok, balance} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        date: ~D[2022-12-05],
        locked: true,
        unlock_datetime: ~U[2022-12-05 11:28:00Z]
      })
      |> Portfolio.Balances.create_balance()

    balance
  end
end
