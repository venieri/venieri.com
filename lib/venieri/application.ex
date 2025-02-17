defmodule Venieri.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VenieriWeb.Telemetry,
      Venieri.Repo,
      {Oban, Application.fetch_env!(:venieri, Oban)},
      {DNSCluster, query: Application.get_env(:venieri, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Venieri.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Venieri.Finch},
      # Start a worker by calling: Venieri.Worker.start_link(arg)
      # {Venieri.Worker, arg},
      # Start to serve requests, typically the last entry
      VenieriWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Venieri.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VenieriWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
