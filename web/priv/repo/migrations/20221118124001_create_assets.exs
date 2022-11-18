defmodule Portfolio.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string
      add :ticker, :string

      timestamps()
    end
  end
end
