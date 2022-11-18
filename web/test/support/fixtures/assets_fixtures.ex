defmodule Portfolio.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Assets` context.
  """

  @doc """
  Generate a asset.
  """
  def asset_fixture(attrs \\ %{}) do
    {:ok, asset} =
      attrs
      |> Enum.into(%{
        name: "some name",
        ticker: "some ticker"
      })
      |> Portfolio.Assets.create_asset()

    asset
  end

  @doc """
  Generate a price.
  """
  def price_fixture(attrs \\ %{}) do
    {:ok, price} =
      attrs
      |> Enum.into(%{
        date: ~D[2022-11-17],
        price: 120.5
      })
      |> Portfolio.Assets.create_price()

    price
  end
end
