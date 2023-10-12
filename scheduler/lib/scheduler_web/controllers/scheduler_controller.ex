defmodule SchedulerWeb.SchedulerController do
    use SchedulerWeb, :controller

    def create(conn, {"schedule" => schedule}) do
        Scheduler.MySchedule.create(schedule)
    end
end