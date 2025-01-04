defmodule Landover.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :name, :string, null: false
      add :author_id, :integer, null: false
      add :completed_at, :naive_datetime
      add :metadata, :jsonb
      add :private, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create index(:stories, :name)
    create index(:stories, :author_id)
    create index(:stories, :completed_at)
    create index(:stories, :metadata, using: :gin)
    create index(:stories, :private)
  end
end
