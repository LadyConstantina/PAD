defmodule Scheduler.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scheduler.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        group_name: "some group_name",
        university: "some university"
      })
      |> Scheduler.Groups.create_group()

    group
  end
end
