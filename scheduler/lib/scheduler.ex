defmodule Scheduler.Supervisor do
  use Supervisor
  require Logger

    def start(_type,_args) do
        start_link()
    end

    def start_link() do
        Logger.info("Starting the Scheduler Supervisor")
        Supervisor.start_link(__MODULE__,[], name: __MODULE__)
    end

    def init(_args) do
        Process.flag(:trap_exit,true)
        workers = [
                Supervisor.child_spec({Schedule,:schedule1},id: :schedule1),
                Supervisor.child_spec({Schedule,:schedule2},id: :schedule2),
                Supervisor.child_spec({Schedule,:schedule3},id: :schedule3),
                ]
        Supervisor.init(workers,strategy: :one_for_one, max_restarts: 2, max_seconds: 10000)
    end 

end

defmodule Scheduler.Schedule do


end
