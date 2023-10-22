defmodule SchedulerWeb.DefaultController do
    use SchedulerWeb, :controller

    def index(conn, _params) do
        send_resp(conn, :ok, "heart beat")
    end
end