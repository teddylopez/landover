defmodule Landover.Repo do
  use Ecto.Repo,
    otp_app: :landover,
    adapter: Ecto.Adapters.Postgres
end
