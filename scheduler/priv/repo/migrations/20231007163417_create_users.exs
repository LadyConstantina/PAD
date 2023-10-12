defmodule Scheduler.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string
      add :group, :string
      add :university, :string
      add :email, :string
      add :password, :string

      timestamps()
    end

    create index(:users, [:full_name, :password])
  end
end
