defmodule SchedulerWeb.SchedulerController do
    use SchedulerWeb, :controller

    def create(conn, %{"schedule" => data, "user_id" => user_id}) do
        GenServer.cast(Scheduler.LoadBalancer,{:new_schedule, data, user_id})
        send_resp(conn, :ok, Jason.encode!("Lessons created succesfully!"))
    end

    def get(conn, %{"user_id" => user_id}) do
        lessons = Scheduler.Lessons.get_lesson_by_user!(user_id)
        render(conn, :show, lessons: lessons)
    end

end