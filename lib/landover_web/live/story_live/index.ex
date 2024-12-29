defmodule LandoverWeb.StoryLive.Index do
  use LandoverWeb, :live_view

  alias Landover.Stories
  alias Landover.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Stories
      <:actions>
        <.link patch={~p"/stories/new"}>
          <.button>New Story</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="stories"
      rows={@streams.stories}
      row_click={fn {_id, story} -> JS.navigate(~p"/stories/#{story}") end}
    >
      <:col :let={{_id, story}} label="Name">{story.name}</:col>
      <:col :let={{_id, story}} label="Created by">
        {story.author.email}
      </:col>
      <:col :let={{_id, story}} label="Completed at">
        {format(story.completed_at)}
      </:col>
      <:col :let={{_id, story}} label="Metadata">{inspect(story.metadata)}</:col>
      <:action :let={{_id, story}}>
        <div class="sr-only">
          <.link navigate={~p"/stories/#{story}"}>Show</.link>
        </div>
        <.link navigate={~p"/stories/#{story}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, story}}>
        <.link
          phx-click={JS.push("delete", value: %{id: story.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :stories, stories())}
  end

  @impl true
  def handle_info({LandoverWeb.StoryLive.FormComponent, {:saved, story}}, socket) do
    {:noreply, stream_insert(socket, :stories, story)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    story = Stories.get_story!(id)
    {:ok, _} = Stories.delete_story(story)

    {:noreply, stream_delete(socket, :stories, story)}
  end

  defp stories do
    Stories.list_stories(%{preload_author: true})
    |> Repo.all()
  end
end
