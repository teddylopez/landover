defmodule LandoverWeb.StoryLive.Edit do
  use LandoverWeb, :live_view

  alias Landover.Stories
  alias Landover.Repo

  alias LandoverWeb.StoryLive.Form.Schema

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={LandoverWeb.StoryLive.FormComponent}
      id={@story.id}
      title={@page_title}
      action={@live_action}
      story={@story}
      patch={~p"/stories/#{@story}"}
      current_user={@current_user}
      form={@form}
      selected_tags={@selected_tags}
    />
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    story = story(id)
    changeset = Schema.new(story)

    socket
    |> assign(:page_title, "#{story.title} — Edit")
    |> assign(:story, story)
    |> assign(:form, to_form(changeset, as: "story_form"))
    |> assign(:selected_tags, Enum.map(story.tags, & &1.name))
    |> ok()
  end

  @impl true
  def handle_event(_event, _unsigned_params, socket) do
    socket |> noreply()
  end

  defp story(id) do
    Stories.list_stories(%{
      id: id,
      preload_author: true,
      preload_tags: true,
      preload_prompts: true
    })
    |> Repo.one!()
  end
end
