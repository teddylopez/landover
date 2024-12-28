defmodule Landover.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LandoverWeb.Telemetry,
      Landover.Repo,
      {DNSCluster, query: Application.get_env(:landover, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Landover.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Landover.Finch},
      # Start a worker by calling: Landover.Worker.start_link(arg)
      # {Landover.Worker, arg},
      # Start to serve requests, typically the last entry
      LandoverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Landover.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LandoverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
