defmodule NotionPlannerWeb.Router do
  use NotionPlannerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/heartbeat", NotionPlannerWeb do
    get "/" , DefaultController, :index
  end

  scope "/api", NotionPlannerWeb do
    pipe_through :api
  end
end
