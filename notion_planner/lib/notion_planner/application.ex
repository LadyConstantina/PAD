defmodule NotionPlanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NotionPlannerWeb.Telemetry,
      # Start the Ecto repository
      # NotionPlanner.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NotionPlanner.PubSub},
      # Start the Endpoint (http/https)
      NotionPlannerWeb.Endpoint,
      NotionPlannerWeb.CommunicationAgent,
      NotionPlanner.MySupervisor
      # Start a worker by calling: NotionPlanner.Worker.start_link(arg)
      # {NotionPlanner.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NotionPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotionPlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
