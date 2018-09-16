defmodule PhoenixIm.ApiController do
  use PhoenixIm.Web, :controller
  alias PhoenixIm.Response
  def sendUser(conn, params) do
    case params do
      %{"username" => username, "data" => data} -> json conn, _sendToUser( username, data)
      _ -> json conn, Response.response(Response.codeInvalidParam(), %{}, "invalid params")
    end
  end

  def _sendToUser(username, data) do
    {:ok, data} = JSON.decode(data)
    case PhoenixIm.SocketContainer.get( username) do
      nil -> Response.response(Response.codeNotFound(), %{}, "Not found user socket")
      socket -> socket = %{socket | joined: true}
                Phoenix.Channel.push(socket, "new_msg", data)
                Response.response(Response.codeIsOk())
    end
  end

  def sendRomm(conn, params) do
    case params do
      %{"room" => room, "data" => data} -> json conn, _sendToRomm(room, data)
      _ -> json conn, Response.response( Response.codeInvalidParam(), %{}, "invalid param")
    end
  end

  def _sendToRomm(room, data) do
    {:ok, data} = JSON.decode(data)
    PhoenixIm.Endpoint.broadcast_from self(), room, "new_msg", data
    Response.response(Response.codeIsOk())
  end
end
