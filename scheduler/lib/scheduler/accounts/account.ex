defmodule Scheduler.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    has_one :user, Scheduler.Users.User
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email,~r/^[^\s]+@[^\s]+$/, message: "Email must contsin @ and no spaces.")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end
end
