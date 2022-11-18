defmodule Portfolio.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assets" do
    field :name, :string
    field :ticker, :string

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:name, :ticker])
    |> validate_required([:name, :ticker])
  end
end
