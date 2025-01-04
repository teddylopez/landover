defmodule LandoverWeb.FormComponents do
  use Phoenix.Component
  use LandoverWeb, :verified_routes
  use Gettext, backend: LandoverWeb.Gettext

  attr(:story_tags, :list, required: true)
  attr(:search_results, :list, required: true)
  attr(:query, :string, required: true)
  attr(:current_focus, :integer, required: true)

  def tag_select_component(assigns) do
    ~H"""
    <div class="py-2 px-3 bg-white border border-gray-400" phx-window-keydown="set-focus">
      <%= for tagging <- @story_tags do %>
        <span class="inline-block text-xs bg-green-400 text-white py-1 px-2 mr-1 mb-1 rounded">
          <span>{tagging.tag.name}</span>
          <a
            href="#"
            class="text-white hover:text-white"
            phx-click="delete"
            phx-value-tagging={tagging.id}
          >
            &times
          </a>
        </span>
      <% end %>
      <input
        type="text"
        class="inline-block text-sm focus:outline-none"
        name="query"
        value={@query}
        phx-debounce="500"
        placeholder="Add tag"
      />
    </div>
    <%= if @search_results != [] do %>
      <div class="relative">
        <div class="absolute z-50 left-0 right-0 rounded border border-gray-100 shadow py-1 bg-white">
          <%= for {search_result, idx} <- Enum.with_index(@search_results) do %>
            {format_search_result(search_result, @query)}
          <% end %>
        </div>
      </div>
    <% end %>
    """
  end

  def format_search_result(search_result, query) do
    name = search_result.name
    split_at = String.length(query)
    {selected, rest} = String.split_at(name, split_at)

    "<strong>#{selected}</strong>#{rest}"
    |> Phoenix.HTML.raw()
  end
end
