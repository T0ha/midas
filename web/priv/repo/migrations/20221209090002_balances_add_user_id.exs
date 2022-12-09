defmodule Portfolio.Repo.Migrations.BalancesAddUserId do
  use Ecto.Migration

  def change do
    alter table(:balances) do
      add :user_id, references(:users)
    end

    drop unique_index(:balances, [:asset_id, :wallet_id, :date])
    create unique_index(:balances, [:user_id, :asset_id, :wallet_id, :date])
  end
end
