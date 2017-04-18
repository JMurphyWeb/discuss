defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  alias Discuss.User
  plug Ueberauth

  def callback conn, params do
    %{assigns: %{ueberauth_auth: auth}} = conn
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: Atom.to_string(auth.provider)}
    changeset = User.changeset(%User{}, user_params)

    sign_in(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    IO.inspect changeset
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
