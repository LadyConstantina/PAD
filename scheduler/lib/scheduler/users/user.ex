defmodule Scheduler.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :full_name, :string
    field :gender, :string
    belongs_to :account, Scheduler.Accounts.Account
    belongs_to :group, Scheduler.Groups.Group

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :group_id, :full_name, :gender])
    |> validate_required([:account_id,:group_id])
  end
end
