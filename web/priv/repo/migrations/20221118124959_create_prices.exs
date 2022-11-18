defmodule Portfolio.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :date, :date, null: false
      add :price, :float, null: false
      add :asset_id, references(:assets, on_delete: :nothing)

      timestamps()
    end

    create index(:prices, [:asset_id])
    create unique_index(:prices, [:date, :asset_id])
  end
end
