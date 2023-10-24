defmodule SchedulerWeb.LessonControllerTest do
  use SchedulerWeb.ConnCase

  import Scheduler.LessonsFixtures

  alias Scheduler.Lessons.Lesson

  @create_attrs %{
    classroom: "some classroom",
    every_week: true,
    lesson: "some lesson",
    on_odd_weeks: true,
    teacher: "some teacher",
    time: "some time",
    user_id: 42
  }
  @update_attrs %{
    classroom: "some updated classroom",
    every_week: false,
    lesson: "some updated lesson",
    on_odd_weeks: false,
    teacher: "some updated teacher",
    time: "some updated time",
    user_id: 43
  }
  @invalid_attrs %{classroom: nil, every_week: nil, lesson: nil, on_odd_weeks: nil, teacher: nil, time: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all lessons", %{conn: conn} do
      conn = get(conn, ~p"/api/lessons")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create lesson" do
    test "renders lesson when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/lessons", lesson: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/lessons/#{id}")

      assert %{
               "id" => ^id,
               "classroom" => "some classroom",
               "every_week" => true,
               "lesson" => "some lesson",
               "on_odd_weeks" => true,
               "teacher" => "some teacher",
               "time" => "some time",
               "user_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lessons", lesson: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update lesson" do
    setup [:create_lesson]

    test "renders lesson when data is valid", %{conn: conn, lesson: %Lesson{id: id} = lesson} do
      conn = put(conn, ~p"/api/lessons/#{lesson}", lesson: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lessons/#{id}")

      assert %{
               "id" => ^id,
               "classroom" => "some updated classroom",
               "every_week" => false,
               "lesson" => "some updated lesson",
               "on_odd_weeks" => false,
               "teacher" => "some updated teacher",
               "time" => "some updated time",
               "user_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, lesson: lesson} do
      conn = put(conn, ~p"/api/lessons/#{lesson}", lesson: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete lesson" do
    setup [:create_lesson]

    test "deletes chosen lesson", %{conn: conn, lesson: lesson} do
      conn = delete(conn, ~p"/api/lessons/#{lesson}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/lessons/#{lesson}")
      end
    end
  end

  defp create_lesson(_) do
    lesson = lesson_fixture()
    %{lesson: lesson}
  end
end
