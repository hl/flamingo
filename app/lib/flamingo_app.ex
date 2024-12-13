defmodule FlamingoApp do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Boundary, deps: [Flamingo, FlamingoWeb]

  @impl Application
  def start(_type, _args) do
    children = [
      FlamingoWeb.Telemetry,
      Flamingo.Infra.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:flamingo, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:flamingo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Flamingo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Flamingo.Finch},
      # Start a worker by calling: Flamingo.Worker.start_link(arg)
      # {Flamingo.Worker, arg},
      # Start to serve requests, typically the last entry
      FlamingoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Flamingo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    FlamingoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
