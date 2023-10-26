defmodule SchedulerWeb.DefaultController do
    use SchedulerWeb, :controller

    def index(conn, _params) do
        send_resp(conn, :ok, "heart beat")
    end

    def update(conn, params) do
        SchedulerWeb.CommunicationAgent.update(params)
        send_resp(conn, :ok, "hello")
    end
end