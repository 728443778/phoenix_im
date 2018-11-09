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
    {:ok, data} = Jason.decode(data)
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
    {:ok, data} = Jason.decode(data)
    PhoenixIm.Endpoint.broadcast_from self(), room, "new_msg", data
    Response.response(Response.codeIsOk())
  end

  def socketContainerInfo(conn , _) do
    json conn, Response.response(Response.codeIsOk(), PhoenixIm.ApiView.render("socket_contaer_info.json", PhoenixIm.SocketContainer.info()))
  end

  def allSocket(conn, _) do
    json conn, Response.response(Response.codeIsOk(), %{"sockets" => PhoenixIm.SocketContainer.getAll() |> formatAllSocket})
  end

  def getOneSocket(conn, %{"username" => username}) do
    json conn, Response.response(Response.codeIsOk(), username |> PhoenixIm.SocketContainer.get |> formatSocket)
  end

  def formatSocket(socket) do
    %{assigns: assigns, channel: channel, channel_pid: channel_pid, handler: handler, join_ref: join_ref, topic: topic,
    transport: transport, transport_pid: transport_pid, pubsub_server: pubsub_server,
    serializer: serializer} = socket
    %{
    assigns: assigns, channel: channel, channel_pid: Inspect.PID.inspect(channel_pid, ""), handler: handler,
    join_ref: join_ref, topic: topic, transport: transport, transport_pid: Inspect.PID.inspect(transport_pid, transport_pid),
    pubsub_server: pubsub_server, serializer: serializer
    }
  end

  def formatAllSocket(sockets) do
    Enum.map(sockets, fn x->_formatAllSocket(x) end)
  end

  def _formatAllSocket(socket) do
    {key, socket} = socket
    formatSocket(socket)
  end

end
