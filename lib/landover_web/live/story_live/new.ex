defmodule LandoverWeb.StoryLive.New do
  use LandoverWeb, :live_view

  alias Landover.Stories.Story

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={LandoverWeb.StoryLive.FormComponent}
      id={@story.id || :new}
      title={@page_title}
      action={:new}
      story={@story}
      patch={~p"/stories"}
      current_user={@current_user}
    />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:page_title, "New Story")
    |> assign(:story, %Story{})
    |> ok()
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket |> noreply()
  end
end
