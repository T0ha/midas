defmodule Portfolio.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :name, :string
    field :type, Ecto.Enum, values: [wallet: 1, exchange: 2, dex: 3, defi: 4, other: 5]
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
