defmodule PhoenixIm.PageController do
  use PhoenixIm.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def socketTest(conn, params) do
    render conn, "socket.html"
  end

end
