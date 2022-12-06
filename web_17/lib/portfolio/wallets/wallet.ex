defmodule Portfolio.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :name, :string
    field :type, Ecto.Enum, values: [:wallet, :exchange, :dex, :defi, :other]
    field :parent_id, :id

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end
end
