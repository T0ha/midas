defmodule Portfolio.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add :key, :string, null: false
      add :secret, :string, null: false

      add :user_id, references(:users, on_delete: :nothing)
      add :wallet_id, references(:wallets, on_delete: :nothing)

      timestamps()
    end

    create index(:api_keys, [:user_id])
    create index(:api_keys, [:wallet_id])

    create unique_index(:api_keys, [:user_id, :wallet_id, :key])
  end
end
