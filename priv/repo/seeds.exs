# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Landover.Repo.insert!(%Landover.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Landover.Accounts.register_user(%{email: "ted@landover.com", password: "password"})

IO.puts("Seeds successfully imported...")
