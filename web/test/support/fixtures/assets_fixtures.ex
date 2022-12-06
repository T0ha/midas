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
        fetch: true,
        gecko_id: "some gecko_id",
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
        currency: "some currency",
        date: ~D[2022-12-05],
        price: 120.5
      })
      |> Portfolio.Assets.create_price()

    price
  end
end
