defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do

  end

  # params will be whatever we initialise the plug with
  # useful if we want to do heavy computations one time only
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
        # conn.assigns.user = user
      true ->
        assign(conn, :user, nil)
    end
  end
end
