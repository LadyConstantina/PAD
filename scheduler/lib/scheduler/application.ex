defmodule Scheduler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SchedulerWeb.Telemetry,
      # Start the Ecto repository
      Scheduler.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Scheduler.PubSub},
      # Start the Endpoint (http/https)
      SchedulerWeb.Endpoint,
      SchedulerWeb.CommunicationAgent,
      # Start Worker pool through Worker Supervisor
      Scheduler.WorkSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scheduler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SchedulerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
