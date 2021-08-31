defmodule AstraeaVirgo.Thrift.Client do
  use GenServer

  @host Application.get_env(:virgo, :rpc)[:host]
  @port Application.get_env(:virgo, :rpc)[:port]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    :thrift_client_util.new(
      @host |> String.to_charlist, @port,
      :data_service_thrift, [protocol: :compact, framed: true]
    )
  end

  def run(func, params) do
    GenServer.call(__MODULE__, %{func: func, params: params})
  end

  def handle_call(%{func: func, params: params}, _from, client) do
    case :thrift_client.call(client, func, params) do
      {client, {:ok, result}} -> {:reply, result, client}
      {client, {:error, reason}} -> {:stop, reason, client}
    end
  end

end
