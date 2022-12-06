defmodule Portfolio.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string, null: false
      add :ticker, :string, null: false
      add :gecko_id, :string, null: false
    end

    create unique_index(:assets, [:name])
  end
end
