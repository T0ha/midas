defmodule Portfolio.Assets.Price do
  use Ecto.Schema
  import Ecto.Changeset
  alias Portfolio.Assets.Asset

  schema "prices" do
    field :date, :date
    field :price, :float
    field :currency, :string
    belongs_to :asset, Asset


    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:date, :price])
    |> validate_required([:date, :price])
  end
end
