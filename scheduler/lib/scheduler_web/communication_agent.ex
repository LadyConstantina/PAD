defmodule SchedulerWeb.CommunicationAgent do
    use Agent
    require Logger

    def start_link(_args) do
        state = get_to_service_discovery()
        Logger.info(state)
        Agent.start_link(fn -> state end, name: __MODULE__)
    end

    def get_to_service_discovery() do
        state = 
        case HTTPoison.get("http://localhost:4010/", [{'name','Scheduler'}, {'host','localhost'}, {'port',System.get_env("PORT")}]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> Jason.decode!(body)
            {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> "Request failed with status code #{status_code}: #{body}"
            {:error, %HTTPoison.Error{reason: reason}} -> "Request failed with error: #{reason}"
        end
        if Enum.member?(state,"Scheduler") do get_to_service_discovery() end
        state
    end

    def get_address(service) do
        services = Agent.get(__MODULE__,& &1)
        case services[service] do
            nil -> {:error,"Service does not exist."}
            _ -> {:ok, services[service]}
        end
    end

    def update(%{"_json" => new_state}) do
        Agent.update(__MODULE__, fn state -> Jason.decode!(new_state) end)
    end
end