defmodule Scheduler.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scheduler.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        full_name: "some full_name",
        gender: "some gender"
      })
      |> Scheduler.Users.create_user()

    user
  end
end
