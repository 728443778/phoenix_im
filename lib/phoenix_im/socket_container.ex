defmodule PhoenixIm.SocketContainer do
  use GenServer
  @table :users_table
  @processName __MODULE__
  def init(_) do
    case :ets.info @table do
      :undefined -> {:ok, :ets.new(@table, [:named_table, read_concurrency: true, write_concurrency: true])}
      _ -> {:ok, @table}
    end
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @processName )
  end

  def get(key) do
    GenServer.call(@processName, {:get, key})
  end

  def delete(key) do
    GenServer.call(@processName, {:delete, key})
  end

  def handle_call({:delete, key}, _from, state) do
    return = :ets.delete(@table, key)
    {:reply, return, nil}
  end

  def handle_call({:get, key}, _from, state) do
    case :ets.lookup(@table, key) do
      [] -> {:reply, nil, nil}
      [{key, value}] -> {:reply, value, nil}
    end
  end

  def insert(key, socket) do
    GenServer.call(@processName, {:insert, {key, socket}})
  end

  def handle_call({:insert, {key, socket}}, from, state) do
    result = :ets.insert(@table, {key, socket})
    {:reply, result, nil}
  end

  def getAll() do
    GenServer.call(@processName, :get_all)
  end

  def handle_call(:get_all, _from, now) do
    {:reply, :ets.tab2list(@table), nil}
  end

  def info() do
    :ets.info @table
  end

end