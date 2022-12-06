defmodule Portfolio.Assets.Price do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prices" do
    field :currency, :string
    field :date, :date
    field :price, :float
    field :asset_id, :id

    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:date, :price, :currency])
    |> validate_required([:date, :price, :currency])
  end
end
