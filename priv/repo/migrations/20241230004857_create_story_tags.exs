defmodule Landover.Repo.Migrations.CreateStoryTags do
  use Ecto.Migration

  def change do
    create table(:story_tags) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :story_id, references(:stories, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:story_tags, [:tag_id])
    create index(:story_tags, [:story_id])
    create unique_index(:story_tags, [:tag_id, :story_id])
  end
end
