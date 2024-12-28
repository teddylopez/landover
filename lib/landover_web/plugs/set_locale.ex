defmodule LandoverWeb.Plugs.SetLocale do
  import Plug.Conn

  alias LandoverWeb.Helpers.GlobalHelpers

  @supported_locales Gettext.known_locales(LandoverWeb.Gettext)

  def init(_options), do: nil

  def call(conn, _options) do
    case fetch_locale_from(conn) do
      nil ->
        assign_locale(conn)

      locale ->
        assign_locale(conn, locale)
    end
  end

  defp fetch_locale_from(conn) do
    (conn.params["locale"] || conn.cookies["locale"])
    |> check_locale
  end

  defp check_locale(locale) when locale in @supported_locales, do: locale
  defp check_locale(_), do: nil

  defp assign_locale(conn), do: assign_locale(conn, Gettext.get_locale())

  defp assign_locale(conn, locale) do
    GlobalHelpers.set_locale(locale)

    conn
    |> put_session(:locale, locale)
    |> put_resp_cookie("locale", locale, max_age: 365 * 24 * 60 * 60)
  end
end
