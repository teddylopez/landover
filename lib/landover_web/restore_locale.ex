defmodule LandoverWeb.RestoreLocale do
  @moduledoc false

  def on_mount(:default, _params, %{"locale" => locale} = _session, socket) do
    LandoverWeb.Gettext |> Gettext.put_locale(locale)
    {:cont, socket}
  end

  # for any logged out routes
  def on_mount(:default, _params, _session, socket), do: {:cont, socket}
end
