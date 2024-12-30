defmodule Landover.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :story_id, references(:stories, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:taggings, [:tag_id])
    create index(:taggings, [:story_id])
    create unique_index(:taggings, [:tag_id, :story_id])
  end
end
