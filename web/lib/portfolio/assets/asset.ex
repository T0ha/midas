defmodule Portfolio.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assets" do
    field :fetch, :boolean, default: false
    field :gecko_id, :string
    field :name, :string
    field :ticker, :string
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:name, :ticker, :gecko_id, :fetch])
    |> validate_required([:name, :ticker, :gecko_id, :fetch])
  end
end
