defmodule SchedulerWeb.Router do
  use SchedulerWeb, :router

  pipeline :check do
    plug :accepts, ["json"]
  end

  scope "/check", SchedulerWeb do
    pipe_through :check
    get "/", DefaultController, :index
  end
end
