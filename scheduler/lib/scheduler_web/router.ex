defmodule SchedulerWeb.Router do
  use SchedulerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SchedulerWeb do
    pipe_through :api
    get "/check", DefaultController, :index
    post "/register", UserController, :create
    post "/login", UserController, :login
    post "/schedule/create", SchedulerController, :create
    get "/schedule",  SchedulerController, :get
    post "/schedule", SchedulerController, :update
    get "/schedule/today", SchedulerController, :get_day_schedule
    post "/deadlines/create", SchedulerController, :create_projects
    get "deadlines", SchedulerController, :get_projects
    post "deadlines", SchedulerController, :update_projects
    get "/deadlines/week", SchedulerController, :get_week_projects
  end
end
