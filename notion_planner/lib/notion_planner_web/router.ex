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
    post "/project", ProjectController, :create_projects
    get "/project", ProjectController, :get_projects
    put "/project", ProjectController, :update_projects
    delete "/project", ProjectController, :delete_projects
    post "/notes", ProjectController, :create_notes
    get "/notes", ProjectController, :get_notes
    put "/notes", ProjectController, :update_notes
    delete "/notes", ProjectController, :delete_notes
    get "/exam", ProjectController, :get_exam_notes
  end
end
