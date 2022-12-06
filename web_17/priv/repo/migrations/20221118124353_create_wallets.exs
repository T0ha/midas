defmodule Portfolio.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :name, :string, null: false
      add :subwallet, :string
      add :type, :integer

      timestamps()
    end
    
    create unique_index(:wallets, [:name, :subwallet])
  end
end
