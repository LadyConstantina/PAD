defmodule SchedulerWeb.Router do
  use SchedulerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/heartbeat", SchedulerWeb do
    get "/", DefaultController, :index
  end

  scope "/api", SchedulerWeb do
    pipe_through :api
    post "/register", UserController, :create
    post "/login", UserController, :login
    post "/schedule", SchedulerController, :create
    get "/schedule",  LessonController, :get
    put "/schedule", LessonController, :update
    delete "/schedule", LessonController, :delete
    get "/schedule/day", LessonController, :get_for_day
    get "/schedule/today", LessonController, :get_for_today
    # post "/deadlines/create", SchedulerController, :create_projects
    # get "deadlines", SchedulerController, :get_projects
    # post "deadlines", SchedulerController, :update_projects
    # get "/deadlines/week", SchedulerController, :get_week_projects
  end
end
