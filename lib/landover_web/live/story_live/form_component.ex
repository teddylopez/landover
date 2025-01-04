defmodule LandoverWeb.StoryLive.FormComponent do
  use LandoverWeb, :live_component

  alias Landover.Repo
  alias Landover.Stories
  alias Landover.Taggable
  alias LandoverWeb.StoryLive.StoryFormSchema

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
        >
          <.input field={@form[:name]} type="text" label="Name your tale..." />

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
    tag_ids =
      params["story_form"]["tag_ids"]
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)

    socket
    |> assign(:selected_tags, selected_tags(tag_ids))
    |> assign_form(params)
    |> noreply()
  end

  @impl true
  def handle_event("update", params, socket) do
    socket
    |> assign_form(params)
    |> noreply()
  end

  def handle_event("save", %{"story_form" => story_params}, socket) do
    with {:ok, output_data} <- StoryFormSchema.submit(socket.assigns.form, story_params) do
      save_story(socket, socket.assigns.action, output_data)
    else
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "story_form"))}
    end
  end

  defp save_story(socket, :edit, story_params) do
    case Stories.update_story(socket.assigns.story, story_params) do
      {:ok, story} ->
        notify_parent({:saved, story})

        {:noreply,
         socket
         |> put_flash(:info, "Story updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_story(socket, :new, story_params) do
    story_params = Map.put(story_params, "author_id", socket.assigns.current_user.id)

    case Stories.create_story(story_params) do
      {:ok, story} ->
        notify_parent({:saved, story})

        {:noreply,
         socket
         |> put_flash(:info, "Story created successfully")
         |> push_navigate(to: ~p"/stories/#{story.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(socket, params) do
    changeset = StoryFormSchema.validate(socket.assigns.form, params["story_form"])
    assign(socket, form: to_form(changeset, as: "story_form"))
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
end
