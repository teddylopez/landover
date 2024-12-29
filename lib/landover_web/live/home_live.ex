defmodule LandoverWeb.HomeLive do
  use LandoverWeb, :live_view

  import LandoverWeb.LayoutComponents

  @impl true
  def render(assigns) do
    ~H"""
    <.single_layout>
      <.content_container>
        <.typeit_text
          id="welcome-back-user"
          text={dgettext("home", "welcome_back", user: @current_user.email)}
        />
      </.content_container>
      <div class="flex items-center mt-8">
        <.link navigate={~p"/stories"}>
          {dgettext("home", "Stories")}
        </.link>
      </div>
    </.single_layout>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket |> ok()
  end
end
