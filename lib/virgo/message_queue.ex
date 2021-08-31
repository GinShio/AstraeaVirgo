defmodule AstraeaVirgo.MessageQueue do
  use GenServer

  @username Application.get_env(:virgo, :amqp)[:username]
  @password Application.get_env(:virgo, :amqp)[:password]
  @host Application.get_env(:virgo, :amqp)[:host]
  @port Application.get_env(:virgo, :amqp)[:port]

  @submission_exchange "astraea_submission_exchange"
  def get_queue_name(language), do: "astraea_submission_#{language}_queue"

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  def init(_opts) do
    {:ok, conn} = AMQP.Connection.open("amqp://#{@username}:#{@password}@#{@host}:#{@port}")
    AMQP.Channel.open(conn)
  end

  def publish(message, language, priority \\ 1) do
    GenServer.cast(
      __MODULE__,
      {__MODULE__, %{router: language, message: message, priority: priority}})
  end

  def handle_cast({__MODULE__, %{router: key, message: message, priority: priority}}, chan) do
    AMQP.Basic.publish(chan, @submission_exchange, key, message, priority: priority)
    {:noreply, chan}
  end

end
