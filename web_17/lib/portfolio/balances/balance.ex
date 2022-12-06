defmodule Portfolio.Balances.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balances" do
    field :amount, :float
    field :date, :date
    field :locked, :boolean, default: false
    field :unlock_datetime, :utc_datetime
    field :asset_id, :id
    field :wallet_id, :id

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:amount, :locked, :unlock_datetime, :date])
    |> validate_required([:amount, :locked, :unlock_datetime, :date])
  end
end
