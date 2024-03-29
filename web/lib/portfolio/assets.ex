defmodule Portfolio.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo
  alias Portfolio.EctoHelpers

  alias Portfolio.Assets.{Asset, Price}
  alias Portfolio.Balances.Balance

  @doc """
  Returns the list of currencies..

  ## Examples

      iex> list_currencies()
      [String.t(), ...]

  """
  def list_currencies do
    from(
      p in Price,
      group_by: p.currency,
      select: p.currency
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets()
      [%Asset{}, ...]

  """
  def list_assets do
    Repo.all(Asset)
  end

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_user_assets(user_id)
      [%Asset{}, ...]

  """
  def list_user_assets(user_id) do
    Repo.all(
      from a in Asset,
        right_join: b in Balance, on: b.asset_id == a.id, 
        where: b.user_id == ^user_id,
        group_by: a.id,
        order_by: a.id,
        select: a
    )
  end

  @doc """
  Gets a single asset.

  Raises `Ecto.NoResultsError` if the Asset does not exist.

  ## Examples

      iex> get_asset!(123)
      %Asset{}

      iex> get_asset!(456)
      ** (Ecto.NoResultsError)

  """
  def get_asset!(id), do: Repo.get!(Asset, id)

  @doc """
  Creates a asset.

  ## Examples

      iex> create_asset(%{field: value})
      {:ok, %Asset{}}

      iex> create_asset(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_asset(attrs \\ %{}) do
    %Asset{}
    |> Asset.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a asset.

  ## Examples

      iex> update_asset(asset, %{field: new_value})
      {:ok, %Asset{}}

      iex> update_asset(asset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_asset(%Asset{} = asset, attrs) do
    asset
    |> Asset.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a asset.

  ## Examples

      iex> delete_asset(asset)
      {:ok, %Asset{}}

      iex> delete_asset(asset)
      {:error, %Ecto.Changeset{}}

  """
  def delete_asset(%Asset{} = asset) do
    Repo.delete(asset)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking asset changes.

  ## Examples

      iex> change_asset(asset)
      %Ecto.Changeset{data: %Asset{}}

  """
  def change_asset(%Asset{} = asset, attrs \\ %{}) do
    Asset.changeset(asset, attrs)
  end


  @doc """
  Returns the list of prices.

  ## Examples

      iex> list_prices(currency, period, [])
      [%Price{}, ...]

  """
  def list_prices(currency \\ "usd", period \\ "day", assets \\ [])

  def list_prices(currency, period, [%Asset{} | _] = assets), do: 
    list_prices(currency, period, Enum.map(assets, & &1.id))

  def list_prices(currency, period, asset_ids) do
    from(
      p in Price,
      left_join: po in Price,
        on: p.asset_id == po.asset_id 
          and po.date == date_add(p.date, -1, ^period)
          and p.currency == po.currency,
      order_by: [desc: p.date, asc: p.asset_id],
      select: %{
        date: p.date, 
        asset_id: p.asset_id,
        price: p.price,
        delta: (p.price - po.price) / po.price * 100.0
      }
    )
    |> where([p], p.currency == ^currency)
    |> case do
      q when asset_ids != [] ->
        where(q, [p], p.asset_id in ^asset_ids)
      q ->
        q
      end
    |> EctoHelpers.period_query(period)
    |> IO.inspect()
    |> Repo.all()
  end


  @doc """
  Gets a single price.

  Raises `Ecto.NoResultsError` if the Price does not exist.

  ## Examples

      iex> get_price!(123)
      %Price{}

      iex> get_price!(456)
      ** (Ecto.NoResultsError)

  """
  def get_price!(id), do: Repo.get!(Price, id)

  @doc """
  Creates a price.

  ## Examples

      iex> create_price(%{field: value})
      {:ok, %Price{}}

      iex> create_price(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_price(attrs \\ %{}) do
    %Price{}
    |> Price.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a price.

  ## Examples

      iex> update_price(price, %{field: new_value})
      {:ok, %Price{}}

      iex> update_price(price, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_price(%Price{} = price, attrs) do
    price
    |> Price.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a price.

  ## Examples

      iex> delete_price(price)
      {:ok, %Price{}}

      iex> delete_price(price)
      {:error, %Ecto.Changeset{}}

  """
  def delete_price(%Price{} = price) do
    Repo.delete(price)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking price changes.

  ## Examples

      iex> change_price(price)
      %Ecto.Changeset{data: %Price{}}

  """
  def change_price(%Price{} = price, attrs \\ %{}) do
    Price.changeset(price, attrs)
  end
end
