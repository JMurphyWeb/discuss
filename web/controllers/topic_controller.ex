defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def edit conn, %{"id" => id} do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update conn, %{"topic" => updated_topic, "id" => id} do
    old_topic = Repo.get(Topic, id)
    changeset = Topic.changeset(old_topic, updated_topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect to: topic_path(conn, :index)
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end

  end

  def index conn, params do
    topics = Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def new conn, _params do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end


  def create conn, %{"topic" => topic} do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end


  end

end
