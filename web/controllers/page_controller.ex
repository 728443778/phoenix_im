defmodule PhoenixIm.PageController do
  use PhoenixIm.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
