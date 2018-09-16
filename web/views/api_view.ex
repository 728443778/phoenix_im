defmodule PhoenixIm.ApiView do
  use PhoenixIm.Web, :view
  def render("socket_contaer_info.json", info) do
    []
  end

  defp getPro(protected) do
    case protected do
      :protected -> true
      _ -> false
    end
  end

  def render("all_socket.json", allSocket) do

  end
end