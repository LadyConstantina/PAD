defmodule NotionPlannerWeb.DefaultController do
    use NotionPlannerWeb, :controller

    def index(conn, _params) do
        text conn, "Notion planner is running in #{Mix.env()} environment"
    end
end