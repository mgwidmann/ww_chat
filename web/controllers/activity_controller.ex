defmodule WwChat.ActivityController do
  use WwChat.Web, :controller

  alias WwChat.Activity

  plug :scrub_params, "activity" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    activities = Repo.all(Activity)
    render(conn, "index.html", activities: activities)
  end

  def new(conn, _params) do
    changeset = Activity.changeset(%Activity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"activity" => activity_params}) do
    changeset = Activity.changeset(%Activity{}, activity_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Activity created successfully.")
      |> redirect(to: activity_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Repo.get(Activity, id)
    render(conn, "show.html", activity: activity)
  end

  def edit(conn, %{"id" => id}) do
    activity = Repo.get(Activity, id)
    changeset = Activity.changeset(activity)
    render(conn, "edit.html", activity: activity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Repo.get(Activity, id)
    changeset = Activity.changeset(activity, activity_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Activity updated successfully.")
      |> redirect(to: activity_path(conn, :index))
    else
      render(conn, "edit.html", activity: activity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Repo.get(Activity, id)
    Repo.delete(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: activity_path(conn, :index))
  end
end
