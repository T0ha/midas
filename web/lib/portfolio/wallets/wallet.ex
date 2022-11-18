defmodule Portfolio.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :name, :string
    field :subwallet, :string
    field :type, :integer

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:name, :subwallet, :type])
    |> validate_required([:name, :subwallet, :type])
  end
end
