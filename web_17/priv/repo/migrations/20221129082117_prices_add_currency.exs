defmodule Portfolio.Repo.Migrations.PricesAddCurrency do
  use Ecto.Migration

  def change do
    alter table(:prices) do
      add :currency, :string, default: "usd"
    end
    drop index(:prices, [:date, :asset_id])
    create unique_index(:prices, [:asset_id, :date, :currency])

  end
end
