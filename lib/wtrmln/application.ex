defmodule Wtrmln.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WtrmlnWeb.Telemetry,
      Wtrmln.Repo,
      {DNSCluster, query: Application.get_env(:wtrmln, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Wtrmln.PubSub},
      # Start a worker by calling: Wtrmln.Worker.start_link(arg)
      # {Wtrmln.Worker, arg},
      # Start to serve requests, typically the last entry
      WtrmlnWeb.Endpoint,
      FunWithFlags.Supervisor,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wtrmln.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WtrmlnWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
