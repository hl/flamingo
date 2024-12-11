defmodule Flamingo.Infra.Repo.Migrations.InitSchema do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :string
      add :description, :string
      add :template, :string
      add :blocks, :map

      timestamps()
    end

    create unique_index(:collections, [:name])

    create table(:pages) do
      add :handle, :string
      add :collection_id, references(:collections, on_delete: :delete_all)
      add :blocks, :map

      timestamps()
    end

    create unique_index(:pages, [:handle])
  end
end
