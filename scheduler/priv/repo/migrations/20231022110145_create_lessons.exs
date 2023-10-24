defmodule Scheduler.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :user_id, :integer
      add :day, :string
      add :time, :string
      add :lesson, :string
      add :teacher, :string
      add :classroom, :string
      add :every_week, :boolean, default: true, null: true
      add :on_odd_weeks, :boolean, default: false, null: false

      timestamps()
    end
  end
end
