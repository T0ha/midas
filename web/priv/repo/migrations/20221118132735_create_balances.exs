defmodule Portfolio.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add :amount, :float
      add :locked, :boolean, default: false, null: false
      add :unlock_datetime, :utc_datetime
      add :asset_id, references(:assets, on_delete: :nothing)
      add :wallet_id, references(:wallets, on_delete: :nothing)

      timestamps()
    end

    create index(:balances, [:asset_id])
    create index(:balances, [:wallet_id])
  end
end
