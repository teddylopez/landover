defmodule Landover.CustomTooling do
  @moduledoc """
  Custom shit I came up with
  """

  # Shortcut for IO.inspect (pp -> Ruby prettyprint)
  defmacro pp(expression) do
    quote do
      dbg(unquote(expression))
      # IO.inspect(unquote(expression))
    end
  end

  # Shared liveview methods:
  def ok(socket), do: {:ok, socket}
  def ok(socket, layout: layout), do: {:ok, socket, layout: layout}
  def noreply(socket), do: {:noreply, socket}
end
