defmodule LandoverWeb.StoryLive.Edit do
  use LandoverWeb, :live_view

  alias Landover.Stories
  alias Landover.Repo

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
    />
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket
    |> assign(:page_title, "Edit Story")
    |> assign(:story, story(id))
    |> ok()
  end

  defp story(id) do
    Stories.list_stories(%{id: id, preload_author: true})
    |> Repo.one!()
  end
end
