defmodule PhoenixIm.RoomChannel do
  use PhoenixIm.Web, :channel

  @doc """
    客户端连接时的处理逻辑，可以在这里做连接验证，现在没做连接验证
  """
  def join("room:" <> room_id, params, socket) do
    %{"username" => username} = params
    socket = assign(socket, :room_id, room_id)  #   room id使用字符串
    socket = assign(socket, :username, username) # 用户唯一的标志也使用字符串
    # 把socket 管理起来，便于其他应用向连接指向的用户发消息
    PhoenixIm.SocketContainer.insert(username, socket)
    {:ok, socket}
  end

  def terminate(params, socket) do
    PhoenixIm.SocketContainer.delete(socket.assigns.username)
    {:stop, :shutdown, socket}
  end

  def handle_info(:ping, socket) do
    push socket, "ping", %{}
    {:noreply, socket}
  end

  def handle_in("new_msg", params, socket) do
    broadcast! socket, "new_msg", %{"username" => socket.assigns.username, "data" => params}
    {:reply, :ok, socket}
  end

end