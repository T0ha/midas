defmodule Portfolio.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add :date, :date, null: false
      add :amount, :float, null: false
      add :locked, :boolean, default: false, null: false
      add :unlock_datetime, :utc_datetime, null: true
      add :asset_id, references(:assets, on_delete: :nothing), null: false
      add :wallet_id, references(:wallets, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:balances, [:asset_id])
    create index(:balances, [:wallet_id])
    create unique_index(:balances, [:asset_id, :wallet_id, :date])
  end
end
