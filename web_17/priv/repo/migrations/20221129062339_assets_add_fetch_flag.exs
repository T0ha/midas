defmodule Portfolio.Repo.Migrations.AssetsAddFetchFlag do
  use Ecto.Migration

  def change do
    alter table(:assets) do
      add :fetch, :boolean, default: false
    end
    create index(:assets, [:fetch])

  end
end
