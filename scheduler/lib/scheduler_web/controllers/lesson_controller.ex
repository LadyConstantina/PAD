defmodule SchedulerWeb.LessonController do
  use SchedulerWeb, :controller
  require Logger

  alias Scheduler.Lessons
  alias Scheduler.Lessons.Lesson

  action_fallback SchedulerWeb.FallbackController

  def index(conn, _params) do
    lessons = Lessons.list_lessons()
    render(conn, :index, lessons: lessons)
  end

  def get(conn, %{"user_id" => user_id}) do
      Process.sleep(10)
      lessons = 
      Lessons.get_lesson_by_user!(user_id)
      |> Enum.map(fn {id, day, time, teacher, lesson, classroom} -> %{lessons_id: id, day: day, time: time, lesson: lesson, teacher: teacher, classroom: classroom} end)
      send_resp(conn, :ok, Jason.encode!(lessons))
  end

  def get_for_day(conn, %{"user_id" => user_id, "day" => day}) do
    lessons = 
      Lessons.get_lesson_by_day!(user_id, day, true, false)
      |> Enum.map(fn {id, day, time, teacher, lesson, classroom} -> %{lesson_id: id, day: day, time: time, lesson: lesson, teacher: teacher, classroom: classroom} end)
    
    rare_lessons = 
      Lessons.get_lesson_by_day!(user_id, day, false, is_odd_week())
      |> Enum.map(fn {id, day, time, teacher, lesson, classroom} -> %{lesson_id: id, day: day, time: time, lesson: lesson, teacher: teacher, classroom: classroom} end)

      send_resp(conn, :ok, Jason.encode!(lessons ++ rare_lessons))
  end

  def get_for_today(conn, %{"user_id" => user_id}) do
    today = Date.utc_today()
    map_nr_to_day = %{ 1 => "monday", 2 => "tuesday", 3 => "wednesday", 4 => "thursday", 5 => "friday", 6 => "saturday", 7 => "sunday"}
    day = map_nr_to_day[Date.day_of_week(today)]
    lessons = 
      Lessons.get_lesson_by_day!(user_id, day, true, false)
      |> Enum.map(fn {id, day, time, teacher, lesson, classroom} -> %{lesson_id: id, day: day, time: time, lesson: lesson, teacher: teacher, classroom: classroom} end)
    
    rare_lessons = 
      Lessons.get_lesson_by_day!(user_id, day, false, is_odd_week())
      |> Enum.map(fn {id, day, time, teacher, lesson, classroom} -> %{lesson_id: id, day: day, time: time, lesson: lesson, teacher: teacher, classroom: classroom} end)

      send_resp(conn, :ok, Jason.encode!(lessons ++ rare_lessons))
  end

  def is_odd_week() do
    today = Date.utc_today()
    day_of_week = Date.day_of_week(today)
    days_to_monday = rem(1+day_of_week, 7)
    monday_date = Date.add(today, days_to_monday)
    case rem(monday_date.day, 2) do
        0 -> false
        1 -> true
    end
  end

  def create(conn, %{"lesson" => lesson_params}) do
    with {:ok, %Lesson{} = lesson} <- Lessons.create_lesson(lesson_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lessons/#{lesson}")
      |> render(:show, lesson: lesson)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)
    render(conn, :show, lesson: lesson)
  end

  def update(conn, %{"id" => id, "lesson" => lesson_params}) do
    lesson = Lessons.get_lesson!(id)

    with {:ok, %Lesson{} = lesson} <- Lessons.update_lesson(lesson, lesson_params) do
      render(conn, :show, lesson: lesson)
    end
  end

  def delete(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)

    with {:ok, %Lesson{}} <- Lessons.delete_lesson(lesson) do
      send_resp(conn, :no_content, "")
    end
  end
end
