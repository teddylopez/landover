defmodule LandoverWeb.StoryLive.New do
  use LandoverWeb, :live_view

  alias LandoverWeb.StoryLive.Form.Schema
  alias LandoverWeb.StoryLive.Form.PromptSchema

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
      form={@form}
      selected_tags={@selected_tags}
    />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    story = %Schema{prompt_fields: [%PromptSchema{}]}
    changeset = Schema.changeset(story)

    socket
    |> assign(:page_title, "New Story")
    |> assign(:story, story)
    |> assign(:form, to_form(changeset, as: "story_form"))
    |> assign(:selected_tags, [])
    |> ok()
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket |> noreply()
  end

  @impl true
  def handle_event(_, _, socket) do
    socket |> noreply()
  end
end
