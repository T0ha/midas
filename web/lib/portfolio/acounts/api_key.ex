defmodule Portfolio.Acounts.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "api_keys" do
    field :key, :string
    field :secret, :string
    field :user_id, :id
    field :wallet_id, :id

    timestamps()
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:key, :secret])
    |> validate_required([:key, :secret])
  end
end
