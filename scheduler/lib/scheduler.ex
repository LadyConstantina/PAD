defmodule Scheduler.WorkSupervisor do
  use Supervisor
  require Logger

    def start_link(_args) do
        Logger.info("Starting the Scheduler Supervisor")
        Supervisor.start_link(__MODULE__,[], name: __MODULE__)
    end

    def init(_args) do
        Process.flag(:trap_exit,true)
        workers = [
                Supervisor.child_spec({Scheduler.SchedulerWorker,:scheduler1},id: :scheduler1),
                Supervisor.child_spec({Scheduler.SchedulerWorker,:scheduler2},id: :scheduler2),
                Supervisor.child_spec({Scheduler.SchedulerWorker,:scheduler3},id: :scheduler3),
                Supervisor.child_spec(Scheduler.LoadBalancer, id: __MODULE__)
                ]
        Supervisor.init(workers,strategy: :one_for_one, max_restarts: 2, max_seconds: 10000)
    end 

end

defmodule Scheduler.LoadBalancer do
    use GenServer

    def start_link(_args) do
        GenServer.start_link(__MODULE__,0, name: __MODULE__)
    end

    def init(value) do
        {:ok, value}
    end

    def handle_cast({:new_schedule, data, user_id}, state) do
        GenServer.cast(Scheduler.LoadBalancer,{:schedule,"monday", data["monday"], user_id})
        GenServer.cast(Scheduler.LoadBalancer,{:schedule,"tuesday", data["tuesday"], user_id})
        GenServer.cast(Scheduler.LoadBalancer,{:schedule,"wednesday", data["wednesday"], user_id})
        GenServer.cast(Scheduler.LoadBalancer,{:schedule,"thursday", data["thursday"], user_id})
        GenServer.cast(Scheduler.LoadBalancer,{:schedule,"friday", data["friday"], user_id})
        {:noreply,state}
    end

    def handle_cast({:schedule, day, data, user_id}, state) do
        id = rem(state + 1, 3) + 1
        worker = :"scheduler#{id}"
        GenServer.cast(worker,{:schedule, day, data, user_id})
        {:noreply,state+1}
    end

end

defmodule Scheduler.SchedulerWorker do
    use GenServer
    require Logger
    alias Scheduler.Lessons

    def start_link(name) do
        GenServer.start_link(__MODULE__,name, name: name)
    end

    def init(name) do
        {:ok, name}
    end

    def handle_cast({:schedule, day, data, user_id}, state) do
        Map.keys(data) -- ["even_week", "odd_week"]
        |> Enum.map(fn key -> %{user_id: user_id, day: day, time: key, lesson: Enum.fetch!(data[key],0), teacher: Enum.fetch!(data[key],1), classroom: Enum.fetch!(data[key],2)} end)
        |> Enum.map(fn lesson_obj -> Scheduler.Lessons.create_lesson(lesson_obj) end)

        case data["odd_week"] do
            nil -> {:ok}
            _ -> Map.keys(data["odd_week"])
                |> Enum.map(fn key -> %{user_id: user_id, day: day, time: key, lesson: Enum.fetch!(data["odd_week"][key],0), teacher: Enum.fetch!(data["odd_week"][key],1), classroom: Enum.fetch!(data["odd_week"][key],2), every_week: false, on_odd_weeks: true} end)
                |> Enum.map(fn lesson_obj -> Scheduler.Lessons.create_lesson(lesson_obj) end)
        end
        case data["even_week"] do
            nil -> {:ok}
            _ -> Map.keys(data["even_week"])
                |> Enum.map(fn key -> %{user_id: user_id, day: day, time: key, lesson: Enum.fetch!(data["even_week"][key],0), teacher: Enum.fetch!(data["even_week"][key],1), classroom: Enum.fetch!(data["even_week"][key],2), every_week: false, on_odd_weeks: false} end)
                |> Enum.map(fn lesson_obj -> Scheduler.Lessons.create_lesson(lesson_obj) end)
        end
        {:noreply, state}
    end


end
