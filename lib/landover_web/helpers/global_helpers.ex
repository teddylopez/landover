defmodule LandoverWeb.Helpers.GlobalHelpers do
  def set_locale(locale), do: ScoutedWeb.Gettext |> Gettext.put_locale(locale)

  def new_locale(_conn, locale, language_title) do
    """
    <a href=\"\?locale=#{locale}\">#{language_title}</a>
    """
    |> Phoenix.HTML.raw()
  end

  def highlight_locale(conn, locale_option) do
    locale = Map.get(conn.cookies, "locale")

    if locale == locale_option,
      do: "text-gray-500 dark:text-dark-offset-lighter",
      else: "text-gray-300 dark:text-dark-offset"
  end
end
