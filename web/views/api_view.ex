defmodule PhoenixIm.ApiView do
  use PhoenixIm.Web, :view
  def render("socket_contaer_info.json", info) do
    %{id: id, read_concurrency: read_concurrency, write_concurrency: write_concurrency,
                                                                  compressed: compressed,
                                                                  memory: memory,
                                                                        owner: owner,
                                                                        heir: heir,
                                                                            name: name,
                                                                            size: size,
                                                                                node: node,
                                                                                named_table: named_table,
                                                                                           type: type,
                                                                                           keypos: keypos,
                                                                                                 protection: protection} = info
    %{
#    id: id,
    read_concurrency: read_concurrency,
    write_concurrency: write_concurrency,
    compressed: compressed,
    memory: memory,
    owner: Inspect.PID.inspect(owner, ""),
    heir: Atom.to_string(heir),
    name: Atom.to_string(name),
    size: size,
    node: Atom.to_string(node),
    named_table: Atom.to_string(named_table),
    type: Atom.to_string(type),
    keypos: keypos,
    protection: Atom.to_string(protection)

    }
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