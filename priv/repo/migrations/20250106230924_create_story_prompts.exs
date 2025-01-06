defmodule Landover.Repo.Migrations.CreateStoryPrompts do
  use Ecto.Migration

  def change do
    create table(:story_prompts) do
      add :order, :integer
      add :text, :text
      add :story_id, references(:stories, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:story_prompts, [:story_id])
  end
end
