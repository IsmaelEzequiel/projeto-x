defmodule WealthWave.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WealthWaveWeb.Telemetry,
      WealthWave.Repo,
      {DNSCluster, query: Application.get_env(:wealth_wave, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WealthWave.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WealthWave.Finch},
      # Start a worker by calling: WealthWave.Worker.start_link(arg)
      # {WealthWave.Worker, arg},
      # Start to serve requests, typically the last entry
      WealthWaveWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WealthWave.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WealthWaveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
