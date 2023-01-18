defmodule Portfolio.Balances do
  @moduledoc """
  The Balances context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Accounts.User
  alias Portfolio.Balances.Balance

  @doc """
  Returns the list of balances.

  ## Examples

      iex> list_balances()
      [%Balance{}, ...]

  """
  def list_balances do
    Repo.all(Balance)
  end

  @doc """
  Returns the list of balances.

  ## Examples

      iex> list_balances_for_user(1, "usd")
      [%Balance{}, ...]

  """
  def list_balances_for_user(%User{id: id}), do: 
      list_balances_for_user(id)

  def list_balances_for_user(user_id) do
    from(b in Balance, 
      join: a in assoc(b, :asset),
      where: b.user_id == ^user_id,
      order_by: [asc: b.date, asc: b.asset_id],
      group_by: [b.date, b.asset_id, a.ticker],
      select: %{date: b.date, asset_id: b.asset_id, asset: a.ticker, amount: sum(b.amount)}
    )
    |> Repo.all()
  end

  @doc """
  Gets a single balance.

  Raises `Ecto.NoResultsError` if the Balance does not exist.

  ## Examples

      iex> get_balance!(123)
      %Balance{}

      iex> get_balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_balance!(id), do: Repo.get!(Balance, id)

  @doc """
  Creates a balance.

  ## Examples

      iex> create_balance(%{field: value})
      {:ok, %Balance{}}

      iex> create_balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_balance(attrs \\ %{}) do
    %Balance{}
    |> Balance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a balance.

  ## Examples

      iex> update_balance(balance, %{field: new_value})
      {:ok, %Balance{}}

      iex> update_balance(balance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_balance(%Balance{} = balance, attrs) do
    balance
    |> Balance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a balance.

  ## Examples

      iex> delete_balance(balance)
      {:ok, %Balance{}}

      iex> delete_balance(balance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_balance(%Balance{} = balance) do
    Repo.delete(balance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking balance changes.

  ## Examples

      iex> change_balance(balance)
      %Ecto.Changeset{data: %Balance{}}

  """
  def change_balance(%Balance{} = balance, attrs \\ %{}) do
    Balance.changeset(balance, attrs)
  end
end
