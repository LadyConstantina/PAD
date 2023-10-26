defmodule NotionPlanner.MySupervisor do
  use Supervisor
  require Logger

    def start_link(_args) do
        Logger.info("Starting the Scheduler Supervisor")
        Supervisor.start_link(__MODULE__,[], name: __MODULE__)
    end

    def init(_args) do
        Process.flag(:trap_exit,true)
        workers = [
                Supervisor.child_spec(NotionPlanner.ProjectsDataBase,id: :PDataBase),
                Supervisor.child_spec(NotionPlanner.NotesDataBase,id: :NDataBase)
                ]
        Supervisor.init(workers,strategy: :one_for_one, max_restarts: 2, max_seconds: 10000)
    end
end

defmodule NotionPlanner.ProjectsDataBase do
    use Agent
    require Logger

    def start_link(_args) do
        Logger.info("DataBase started!")
        Agent.start_link(fn -> 0 end, name: __MODULE__)
        upload('projects_database.json')
        {:ok, self()}
    end

    def upload(path) do
        if File.exists?(path) do
                    :ets.file2tab('projects_database.json')
                else
                    list = []
                    :ets.new(:projects_database, [:set, :public, :named_table])
                end
    end

    def update() do
        mess = :ets.tab2file(:projects_database,'projects_database.json')
        :ok
    end

    def store({data, src}) do
      Agent.update(__MODULE__,&(&1 + 1))
      id = Agent.get(__MODULE__, fn x -> x end)
      :ets.insert(:projects_database, {id, data, src})
      update()
    end

    def remove(id) do
        [{id,data,src}] = :ets.lookup(:projects_database,id)
        :ets.delete(:projects_database, id)
        update()
    end

    def get_all(user_id) do
      data = :ets.match(:projects_database,{:_,:"$1",user_id})
      data
    end
end

defmodule NotionPlanner.NotesDataBase do
    use Agent
    require Logger

    def start_link(_args) do
        Logger.info("DataBase started!")
        Agent.start_link(fn -> 0 end, name: __MODULE__)
        upload('notes_database.json')
        {:ok, self()}
    end

    def upload(path) do
        if File.exists?(path) do
                    :ets.file2tab('notes_database.json')
                else
                    list = []
                    :ets.new(:notes_database, [:set, :public, :named_table])
                end
    end

    def update() do
        mess = :ets.tab2file(:notes_database,'notes_database.json')
        :ok
    end

    def store({data, src}) do
        Agent.update(__MODULE__,&(&1 + 1))
        id = Agent.get(__MODULE__, fn x -> x end)
        status = :ets.insert(:notes_database, {id, data, src})
        update()
    end

    def remove(id) do
        [{id,data,src}] = :ets.lookup(:notes_database,id)
        :ets.delete(:notes_database, id)
        update()
    end

    def get_all(user_id) do
      list = :ets.match(:notes_database,{:_,:"$1",user_id})
      list
    end
end