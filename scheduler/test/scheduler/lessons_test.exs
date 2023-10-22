defmodule Scheduler.LessonsTest do
  use Scheduler.DataCase

  alias Scheduler.Lessons

  describe "lessons" do
    alias Scheduler.Lessons.Lesson

    import Scheduler.LessonsFixtures

    @invalid_attrs %{classroom: nil, every_week: nil, lesson: nil, on_odd_weeks: nil, teacher: nil, time: nil, user_id: nil}

    test "list_lessons/0 returns all lessons" do
      lesson = lesson_fixture()
      assert Lessons.list_lessons() == [lesson]
    end

    test "get_lesson!/1 returns the lesson with given id" do
      lesson = lesson_fixture()
      assert Lessons.get_lesson!(lesson.id) == lesson
    end

    test "create_lesson/1 with valid data creates a lesson" do
      valid_attrs = %{classroom: "some classroom", every_week: true, lesson: "some lesson", on_odd_weeks: true, teacher: "some teacher", time: "some time", user_id: 42}

      assert {:ok, %Lesson{} = lesson} = Lessons.create_lesson(valid_attrs)
      assert lesson.classroom == "some classroom"
      assert lesson.every_week == true
      assert lesson.lesson == "some lesson"
      assert lesson.on_odd_weeks == true
      assert lesson.teacher == "some teacher"
      assert lesson.time == "some time"
      assert lesson.user_id == 42
    end

    test "create_lesson/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lessons.create_lesson(@invalid_attrs)
    end

    test "update_lesson/2 with valid data updates the lesson" do
      lesson = lesson_fixture()
      update_attrs = %{classroom: "some updated classroom", every_week: false, lesson: "some updated lesson", on_odd_weeks: false, teacher: "some updated teacher", time: "some updated time", user_id: 43}

      assert {:ok, %Lesson{} = lesson} = Lessons.update_lesson(lesson, update_attrs)
      assert lesson.classroom == "some updated classroom"
      assert lesson.every_week == false
      assert lesson.lesson == "some updated lesson"
      assert lesson.on_odd_weeks == false
      assert lesson.teacher == "some updated teacher"
      assert lesson.time == "some updated time"
      assert lesson.user_id == 43
    end

    test "update_lesson/2 with invalid data returns error changeset" do
      lesson = lesson_fixture()
      assert {:error, %Ecto.Changeset{}} = Lessons.update_lesson(lesson, @invalid_attrs)
      assert lesson == Lessons.get_lesson!(lesson.id)
    end

    test "delete_lesson/1 deletes the lesson" do
      lesson = lesson_fixture()
      assert {:ok, %Lesson{}} = Lessons.delete_lesson(lesson)
      assert_raise Ecto.NoResultsError, fn -> Lessons.get_lesson!(lesson.id) end
    end

    test "change_lesson/1 returns a lesson changeset" do
      lesson = lesson_fixture()
      assert %Ecto.Changeset{} = Lessons.change_lesson(lesson)
    end
  end
end
