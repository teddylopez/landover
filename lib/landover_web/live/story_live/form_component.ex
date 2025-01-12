defmodule LandoverWeb.StoryLive.FormComponent do
  use LandoverWeb, :live_component

  alias Landover.Repo
  alias Landover.Stories
  alias Landover.StoryPrompts.StoryPrompt
  alias Landover.Taggable
  alias LandoverWeb.StoryLive.Form.Schema

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.content_container>
        <.header>
          {@title}
          <:subtitle>Use this form to manage story records in your database.</:subtitle>
        </.header>

        <.simple_form
          for={@form}
          id="story-form"
          phx-target={@myself}
          phx-change="update"
          phx-submit="save"
          phx-auto-recover="recover"
        >
          <.input field={@form[:title]} type="text" label="Title your tale..." />

          <.input type="checkbox" field={@form[:private]} label="Keep story private?" />

          <.label>
            {dgettext("Stories", "Genres")}
          </.label>

          <div :if={@selected_tags != []} class="flex items-center flex-wrap">
            <%= for tag <- @selected_tags do %>
              <div class="border border-brand-green dark:border-dark-offset-lighter
                          rounded-sm px-2 py-1 mx-1 my-1 text-xs">
                {tag}
              </div>
            <% end %>
          </div>

          <div class="flex">
            <div class="flex items-center flex-wrap border border-brand-green
                        dark:border-dark-offset-lighter p-2 rounded-sm">
              <.checkgroup field={@form[:tag_ids]} options={genre_options()} />
            </div>
          </div>
          <div class="mt-8">
            <.label>
              {dgettext("Stories", "Prompts")}
            </.label>

            <.inputs_for :let={prompt} field={@form[:prompt_fields]}>
              <div class="border border-2 border-dark-offset p-8 mt-4">
                <div class="flex items-center justify-end">
                  <.button
                    type="button"
                    variant="secondary"
                    name={@form[:prompt_fields_drop].name <> "[]"}
                    value={prompt.index}
                    phx-click={JS.dispatch("change")}
                    class="!border-none"
                  >
                    <.icon name="hero-x-circle-solid" class="w-6 h-6 text-rose-400" />
                  </.button>
                </div>
                <input
                  name={@form[:prompt_fields_order].name <> "[]"}
                  type="hidden"
                  value={prompt.index}
                />
                <.input field={prompt[:text]} type="textarea" placeholder="Enter a prompt" />
              </div>
            </.inputs_for>

            <%= if error = @form.errors[:prompt_fields] do %>
              <%= for {msg, _opts} <- List.wrap(error) do %>
                <.error>Your story {msg}</.error>
              <% end %>
            <% end %>

            <input type="hidden" name={@form[:prompt_fields_drop].name <> "[]"} />

            <div class="flex justify-end mt-4">
              <.button
                type="button"
                variant="secondary"
                name={@form[:prompt_fields_order].name <> "[]"}
                value="new"
                phx-click={JS.dispatch("change")}
              >
                Add Prompt
              </.button>
            </div>
          </div>
          <:actions>
            <.button phx-disable-with="Saving...">Save Story</.button>
          </:actions>
        </.simple_form>
      </.content_container>
    </div>
    """
  end

  @impl true
  def handle_event("update", %{"_target" => ["story_form", "tag_ids"]} = params, socket) do
    socket
    |> assign_selected_tags(params)
    |> assign_form(params)
    |> noreply()
  end

  @impl true
  def handle_event("update", params, socket) do
    socket
    |> assign_form(params)
    |> noreply()
  end

  @impl true
  def handle_event("recover", params, socket) do
    socket
    |> assign_selected_tags(params)
    |> assign_form(params)
    |> noreply()
  end

  def handle_event("save", %{"story_form" => story_params}, socket) do
    story_params = format_story_prompts(story_params)

    with {:ok, output_data} <- Schema.submit(socket.assigns.form, story_params) do
      save_story(socket, socket.assigns.action, output_data)
    else
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "story_form"))}
    end
  end

  defp save_story(socket, action, story_params) do
    story_params =
      story_params
      |> Map.update!("prompts", &transform_prompts/1)
      |> add_author_id(socket)

    case persist_story(socket, action, story_params) do
      {:ok, story} ->
        notify_parent({:saved, story})

        {:noreply,
         socket
         |> put_flash(:info, story_flash_message(action))
         |> push_navigate(to: navigate_to(action, story, socket))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp transform_prompts(prompts) do
    Enum.map(prompts, fn prompt ->
      %StoryPrompt{text: prompt.text, order: prompt._persistent_id}
    end)
  end

  defp add_author_id(params, socket) do
    params
    |> Map.put("author_id", socket.assigns.current_user.id)
  end

  defp persist_story(socket, :edit, story_params),
    do: Stories.update_story(socket.assigns.story, story_params)

  defp persist_story(_, :new, story_params), do: Stories.create_story(story_params)

  defp story_flash_message(:edit), do: "Story updated successfully"
  defp story_flash_message(:new), do: "Story created successfully"

  defp navigate_to(:edit, _story, socket), do: socket.assigns.patch
  defp navigate_to(:new, story, _socket), do: ~p"/stories/#{story.id}"

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(socket, params) do
    changeset = Schema.validate(socket.assigns.form, params["story_form"])
    assign(socket, form: to_form(changeset, as: "story_form"))
  end

  defp assign_selected_tags(socket, params) do
    tag_ids =
      params["story_form"]["tag_ids"]
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)

    socket
    |> assign(:selected_tags, selected_tags(tag_ids))
  end

  defp genre_options do
    Taggable.list_tags(%{sort_by: {:name, :asc}})
    |> Repo.all()
    |> Enum.map(&{&1.name, "#{&1.id}"})
  end

  defp selected_tags(tag_ids) do
    Taggable.list_tags(%{id: tag_ids, sort_by: {:name, :asc}})
    |> Repo.all()
    |> Enum.map(& &1.name)
  end

  defp format_story_prompts(story_params) do
    prompts =
      Map.get(story_params, "prompt_fields", [])
      |> Enum.map(fn {index, attrs} ->
        %{"order" => index, "text" => attrs["text"]}
      end)

    Map.put(story_params, "prompt_fields", prompts)
  end
end
