defmodule LandoverWeb.StoryLive.Index do
  use LandoverWeb, :live_view

  alias Landover.Stories
  alias Landover.Stories.Story
  alias Landover.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :stories, stories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Story")
    |> assign(:story, Stories.get_story!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Story")
    |> assign(:story, %Story{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stories")
    |> assign(:story, nil)
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