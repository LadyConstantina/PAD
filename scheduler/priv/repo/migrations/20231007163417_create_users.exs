defmodule Scheduler.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string
      add :gender, :string
      add :account_id, references(:accounts, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)

      timestamps()
    end

    create index(:users, [:account_id, :group_id])
  end
end
