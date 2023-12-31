defmodule Scheduler.Lessons do
  @moduledoc """
  The Lessons context.
  """

  import Ecto.Query, warn: false
  alias Scheduler.Repo

  alias Scheduler.Lessons.Lesson

  @doc """
  Returns the list of lessons.

  ## Examples

      iex> list_lessons()
      [%Lesson{}, ...]

  """
  def list_lessons do
    Repo.all(Lesson)
  end

  @doc """
  Gets a single lesson.

  Raises `Ecto.NoResultsError` if the Lesson does not exist.

  ## Examples

      iex> get_lesson!(123)
      %Lesson{}

      iex> get_lesson!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lesson!(id), do: Repo.get!(Lesson, id)

  def get_lesson_by_user!(user_id) do
    Lesson
    |> where([lesson], lesson.user_id == ^String.to_integer(user_id))
    |> select([lesson],{lesson.id, lesson.day, lesson.time, lesson.teacher, lesson.lesson, lesson.classroom})
    |> Repo.all
  end

  def get_lesson_by_day!(user_id, day, every_week, on_odd_weeks) do
    Lesson
    |> where([lesson], lesson.user_id == ^String.to_integer(user_id) and lesson.day == ^day and lesson.every_week == ^every_week and lesson.on_odd_weeks == ^on_odd_weeks)
    |> select([lesson],{lesson.id, lesson.day, lesson.time, lesson.teacher, lesson.lesson, lesson.classroom})
    |> Repo.all
  end
  @doc """
  Creates a lesson.

  ## Examples

      iex> create_lesson(%{field: value})
      {:ok, %Lesson{}}

      iex> create_lesson(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lesson(attrs \\ %{}) do
    %Lesson{}
    |> Lesson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson.

  ## Examples

      iex> update_lesson(lesson, %{field: new_value})
      {:ok, %Lesson{}}

      iex> update_lesson(lesson, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lesson(%Lesson{} = lesson, attrs) do
    lesson
    |> Lesson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson.

  ## Examples

      iex> delete_lesson(lesson)
      {:ok, %Lesson{}}

      iex> delete_lesson(lesson)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lesson(%Lesson{} = lesson) do
    Repo.delete(lesson)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson changes.

  ## Examples

      iex> change_lesson(lesson)
      %Ecto.Changeset{data: %Lesson{}}

  """
  def change_lesson(%Lesson{} = lesson, attrs \\ %{}) do
    Lesson.changeset(lesson, attrs)
  end
end
