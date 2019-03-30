defmodule Shortage.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def change do
    create table(:visits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :visited_on, :date
      add :count, :integer
      add :link_id, references(:links, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:visits, [:link_id])
    create unique_index(:visits, [:link_id, :visited_on])
  end
end
