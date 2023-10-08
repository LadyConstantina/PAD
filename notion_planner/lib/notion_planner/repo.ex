defmodule NotionPlanner.Repo do
  use Ecto.Repo,
    otp_app: :notion_planner,
    adapter: Ecto.Adapters.Postgres
end
