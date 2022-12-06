defmodule Portfolio.Repo.Migrations.WalletsAddParent do
  use Ecto.Migration

  def change do
    alter table(:wallets) do
      remove :subwallet, :string
      add :parent_id, references(:wallets)
    end
  end
end
