defmodule Portfolio.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string, null: false
      add :ticker, :string, null: false

      timestamps()
    end

    create unique_index(:assets, [:name])
  end
end
