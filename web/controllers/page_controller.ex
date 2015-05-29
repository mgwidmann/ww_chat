defmodule WwChat.PageController do
  use WwChat.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
