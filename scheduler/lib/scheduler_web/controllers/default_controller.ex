defmodule SchedulerWeb.DefaultController do
    use SchedulerWeb, :controller

    def index(conn, _params) do
        text conn, "Scheduler is running in #{Mix.env()} environment"
    end
end