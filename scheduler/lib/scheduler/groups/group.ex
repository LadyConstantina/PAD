defmodule Scheduler.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :group_name, :string
    field :university, :string
    has_one :user, Scheduler.Users.User
    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:university, :group_name])
    |> validate_required([:university, :group_name])
    |> validate_length(:group_name, max: 160)
    |> unique_constraint(:group_name)
  end
end
