defmodule Portfolio.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :name, :string
      add :subwallet, :string
      add :type, :integer

      timestamps()
    end
  end
end
