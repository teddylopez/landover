defmodule LandoverWeb.LayoutComponents do
  @moduledoc """
  Provides core UI components.
  """
  use Phoenix.Component
  use LandoverWeb, :verified_routes
  use Gettext, backend: LandoverWeb.Gettext

  import LandoverWeb.PageComponents
  import LandoverWeb.CoreComponents
  import LandoverWeb.Helpers.GlobalHelpers

  alias Phoenix.LiveView.JS

  def navbar(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between py-3 text-sm">
        <div class="flex items-center gap-4 button">
          <.link navigate={~p"/"} class="no-underline px-2">
            Landover
          </.link>
        </div>
        <div class="flex items-center gap-4 font-semibold leading-6
                    text-brand-green dark:text-brand-orange">
          <div class="hidden lg:flex items-center">
            <div>
              <.icon name="hero-globe-americas" class="h-4 w-4 mr-2 text-dark-offset-lighter" />
            </div>
            <div
              class={"pr-2 #{highlight_locale(@socket, "en")} locale-option"}
              phx-click={JS.dispatch("click", to: "#site-nav")}
              id="mobile-en"
            >
              {new_locale(@socket, :en, "en")}
            </div>
            <div
              class={"pr-2 #{highlight_locale(@socket, "es")} locale-option"}
              phx-click={JS.dispatch("click", to: "#site-nav")}
              id="mobile-es"
            >
              {new_locale(@socket, :es, "es")}
            </div>
          </div>
          <.link navigate={~p"/"}>
            {dgettext("home", "About")}
          </.link>
          <div class="flex items-center cursor-pointer">
            <div class="sun-selector hidden dark:inline" phx-hook="AppThemes" id="light-theme-toggle">
              <.icon name="hero-sun" class="h-5 w-5 bg-transparent dark:bg-white" />
            </div>
            <div class="moon-selector inline dark:hidden" phx-hook="AppThemes" id="dark-theme-toggle">
              <.icon name="hero-moon" class="h-5 w-5 bg-gray-900 dark:bg-transparent" />
            </div>
          </div>
        </div>
      </div>
    </header>
    """
  end

  attr(:class, :string, default: "")
  attr(:rest, :global)
  slot(:side_content, required: true)
  slot(:main_content, required: true)

  def main_with_sidebar(assigns) do
    ~H"""
    <div x-data="{ sidebarOpen: false }" class="t-content-container mt-[4rem] lg:mt-[0rem]" {@rest}>
      {render_slot(@side_content)}

      <div class={"flex flex-1 flex-col lg:pl-64 lg:pr-20 lg:mt-[4.5rem] #{@class}"}>
        <main class="flex-1">
          <div class="lg:mt-[1rem] lg:mx-0 max-w-7xl lg:px-4">
            {render_slot(@main_content)}
          </div>
        </main>
      </div>
    </div>
    """
  end

  defp translate_locale_language("es"),
    do: dgettext("shared", "es")

  defp translate_locale_language("en"),
    do: dgettext("shared", "en")

  defp translate_locale_language(""),
    do: dgettext("shared", "en")

  attr(:header, :string, required: false, default: nil)
  attr(:link_text, :string, required: false, default: nil)
  attr(:link_url, :string, required: false, default: nil)
  attr(:class, :string, required: false, default: "")
  attr(:rest, :global, include: ~w(x-data phx_hook))
  slot(:inner_block, required: true)
  slot(:action_button, required: false)

  def single_layout(assigns) do
    ~H"""
    <div class={"lg-mx-0 sm:px-auto px-8 #{@class}"} {@rest}>
      <div class="lg:grid grid-cols-12 gap-6">
        <div class="col-span-12">
          <div :if={@link_url} class="flex flex-row-reverse mx-1 lg:mx-0 mt-4">
            <.link navigate={@link_url}>
              <.button class="shadow-xl border box">
                {@link_text}
              </.button>
            </.link>
          </div>
          <%= if @header do %>
            <.content_container header={@header}>
              {render_slot(@inner_block)}
            </.content_container>
          <% else %>
            {render_slot(@inner_block)}
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  # attr(:header, :string, required: false, default: nil)
  # attr(:class, :string, required: false, default: nil)
  # attr(:modal, :boolean, default: false)
  # attr(:modal_id, :string, required: false)
  # slot(:inner_block, required: true)

  # def content_section(assigns) do
  #   ~H"""
  #   <div
  #     class={"pb-4 mx-1 lg:mx-0 w-full bg-white rounded-sm #{@class}"}
  #     style="border-top: 2px double black;"
  #   >
  #     <div class="flex">
  #       <span
  #         class="flex relative text-xs text-white bg-gray-800 px-2 rounded-br rounded-bl"
  #         style="top: -2px; padding-bottom: 1px;"
  #       >
  #         {@header}
  #         <%= if @modal do %>
  #           <.link phx-click={show_modal(@modal_id)} class="cursor-pointer flex ml-2">
  #             <.icon name="hero-information-circle" class="ml-1 w-4 h-4" />
  #           </.link>
  #         <% end %>
  #       </span>
  #     </div>
  #     {render_slot(@inner_block)}
  #   </div>
  #   """
  # end

  attr(:header, :string, required: false, default: nil)
  slot(:action_button, required: false)
  attr(:link_text, :string, required: false, default: nil)
  attr(:link_url, :string, required: false, default: nil)
  attr(:rest, :global, include: ~w(x-data phx_hook))
  slot(:inner_block, required: true)

  def full_page_layout(assigns) do
    ~H"""
    <div class="mx-1 sm:px-auto lg:px-auto lg:px-auto" {@rest}>
      <div class="h-full lg:h-screen">
        <div class="lg:grid grid-cols-12 gap-6">
          <div class="col-span-12">
            <div :if={@link_url} class="flex flex-row-reverse">
              <div class="mx-0 lg:mx-4 mt-5">
                <.link navigate={@link_url}>
                  <.button class="shadow-xl border box">
                    {@link_text}
                  </.button>
                </.link>
              </div>
            </div>
            <%= if @header do %>
              <.content_container header={@header}>
                {render_slot(@inner_block)}
              </.content_container>
            <% else %>
              {render_slot(@inner_block)}
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
