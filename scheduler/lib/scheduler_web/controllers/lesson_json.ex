defmodule SchedulerWeb.LessonJSON do
  alias Scheduler.Lessons.Lesson

  @doc """
  Renders a list of lessons.
  """
  def index(%{lessons: lessons}) do
    %{data: for(lesson <- lessons, do: data(lesson))}
  end

  @doc """
  Renders a single lesson.
  """
  def show(%{lesson: lesson}) do
    %{data: Enum.map(lesson, fn les -> data(les) end)}
  end

  defp data(%Lesson{} = lesson) do
    %{
      id: lesson.id,
      user_id: lesson.user_id,
      time: lesson.time,
      lesson: lesson.lesson,
      teacher: lesson.teacher,
      classroom: lesson.classroom,
      every_week: lesson.every_week,
      on_odd_weeks: lesson.on_odd_weeks
    }
  end
end
