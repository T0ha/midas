defmodule Portfolio.Balances.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  alias Portfolio.Accounts.User
  alias Portfolio.Assets.{Asset, Wallet}

  schema "balances" do
    field :amount, :float
    field :date, :date
    field :locked, :boolean, default: false
    field :unlock_datetime, :utc_datetime
    belongs_to :asset, Asset
    belongs_to :wallet, Wallet
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:amount, :locked, :unlock_datetime, :date])
    |> validate_required([:amount, :locked, :unlock_datetime, :date])
  end
end
