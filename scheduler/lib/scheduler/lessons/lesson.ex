defmodule Scheduler.Lessons.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lessons" do
    field :classroom, :string
    field :every_week, :boolean, default: true
    field :lesson, :string
    field :on_odd_weeks, :boolean, default: false
    field :teacher, :string
    field :time, :string
    field :day, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:user_id, :day, :time, :lesson, :teacher, :classroom, :every_week, :on_odd_weeks])
    |> validate_required([:user_id, :day, :time, :lesson, :every_week, :on_odd_weeks])
  end
end
