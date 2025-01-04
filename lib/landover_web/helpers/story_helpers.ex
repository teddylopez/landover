defmodule LandoverWeb.Helpers.StoryHelpers do
  alias Landover.Stories.Story

  def visibility(%Story{private: true}), do: "Private"
  def visibility(%Story{private: false}), do: "Public"
end
