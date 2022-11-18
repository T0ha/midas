defmodule Portfolio.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :date, :date
      add :price, :float
      add :asset, references(:assets, on_delete: :nothing)

      timestamps()
    end

    create index(:prices, [:asset])
  end
end
