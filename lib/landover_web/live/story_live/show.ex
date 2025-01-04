defmodule LandoverWeb.StoryLive.Show do
  use LandoverWeb, :live_view

  alias Landover.Repo
  alias Landover.Stories

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Story {@story.id}
      <:subtitle>This is a story record from your database.</:subtitle>
      <:actions>
        <.link navigate={~p"/stories/#{@story}/edit"}>
          <.button>Edit story</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name">
        {@story.name}
      </:item>
      <:item title="Created by">
        {@story.author.email}
      </:item>
      <:item title="Completed at">
        {format(@story.completed_at)}
      </:item>
      <:item title="Metadata">
        {format(@story.metadata)}
      </:item>
      <:item title="Tags">
        {display_tags(@story.tags)}
      </:item>
    </.list>

    <.back navigate={~p"/stories"}>Back to stories</.back>

    <.modal
      :if={@live_action == :edit}
      id="story-modal"
      show
      on_cancel={JS.patch(~p"/stories/#{@story}")}
    >
      <.live_component
        module={LandoverWeb.StoryLive.FormComponent}
        id={@story.id}
        title={@page_title}
        action={@live_action}
        story={@story}
        patch={~p"/stories/#{@story}"}
        current_user={@current_user}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Show Story")
     |> assign(:story, story(id))}
  end

  defp story(id) do
    Stories.list_stories(%{id: id, preload_author: true, preload_tags: true})
    |> Repo.one!()
  end

  defp display_tags(tags) do
    tags
    |> Enum.map(& &1.name)
    |> Enum.join(", ")
    |> format()
  end
end
