defmodule Portfolio.WalletsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Wallets` context.
  """

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(attrs \\ %{}) do
    {:ok, wallet} =
      attrs
      |> Enum.into(%{
        name: "some name",
        subwallet: "some subwallet",
        type: 42
      })
      |> Portfolio.Wallets.create_wallet()

    wallet
  end
end
