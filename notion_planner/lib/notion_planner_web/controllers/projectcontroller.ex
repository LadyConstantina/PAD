defmodule NotionPlannerWeb.ProjectController do
    use NotionPlannerWeb, :controller
    require Logger

    def create_projects(conn,%{"user_id" => user_id, "project" => project_data}) do
        NotionPlanner.ProjectsDataBase.store({project_data,user_id})
        send_resp(conn,:ok,Jason.encode!("Project created!"))
    end

    def get_projects(conn, %{"user_id" => user_id}) do
        projects = NotionPlanner.ProjectsDataBase.get_all(user_id)
        send_resp(conn,:ok,Jason.encode!(projects))
    end

    def create_notes(conn,%{"user_id" => user_id, "notes" => notes_data}) do
        NotionPlanner.NotesDataBase.store({notes_data, user_id})
        send_resp(conn,:ok,Jason.encode!("Notes created!"))
    end

    def get_notes(conn,%{"user_id" => user_id}) do
        notes = NotionPlanner.NotesDataBase.get_all(user_id)
        send_resp(conn,:ok,Jason.encode!(notes))
    end

    def get_exam_notes(conn, %{"user_id" => user_id, "subject" => subject}) do
        notes = NotionPlanner.NotesDataBase.get_all(user_id)
                |> Enum.map(fn [note] -> if Enum.member?(Map.keys(note),subject) do note else [] end end)
        send_resp(conn,:ok,Jason.encode!(notes))
    end

end