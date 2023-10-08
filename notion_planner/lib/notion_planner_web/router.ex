defmodule NotionPlannerWeb.Router do
  use NotionPlannerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NotionPlannerWeb do
    pipe_through :api
    get "/" , DefaultController, :index
  end
end
