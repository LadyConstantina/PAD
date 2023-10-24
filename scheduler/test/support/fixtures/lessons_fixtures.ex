defmodule Scheduler.LessonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scheduler.Lessons` context.
  """

  @doc """
  Generate a lesson.
  """
  def lesson_fixture(attrs \\ %{}) do
    {:ok, lesson} =
      attrs
      |> Enum.into(%{
        classroom: "some classroom",
        every_week: true,
        lesson: "some lesson",
        on_odd_weeks: true,
        teacher: "some teacher",
        time: "some time",
        user_id: 42
      })
      |> Scheduler.Lessons.create_lesson()

    lesson
  end
end
