defmodule LandoverWeb.HomeLive do
  use LandoverWeb, :live_view

  import LandoverWeb.PageComponents
  import LandoverWeb.LayoutComponents

  @impl true
  def render(assigns) do
    ~H"""
    <.single_layout>
      <.content_container>
        {dgettext("home", "welcome")}
      </.content_container>
    </.single_layout>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket |> ok()
  end
end
