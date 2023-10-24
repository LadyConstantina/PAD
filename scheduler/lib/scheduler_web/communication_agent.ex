defmodule SchedulerWeb.CommunicationAgent do
    use Agent
    require Logger

    def start_link(_args) do
        Agent.start_link(fn -> :ok end, name: __MODULE__)
    end

    def get_to_service_discovery() do
        # to be implemented
    end
end