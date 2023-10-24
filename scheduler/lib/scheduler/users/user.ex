defmodule Scheduler.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :full_name, :string
    field :group, :string
    field :university, :string
    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :full_name, :group, :university])
    |> validate_required([:email, :password, :full_name, :group, :university])
    |> unique_constraint([:email])
  end
end
