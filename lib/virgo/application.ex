defmodule AstraeaVirgo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AstraeaVirgoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AstraeaVirgo.PubSub},
      # Start the Endpoint (http/https)
      AstraeaVirgoWeb.Endpoint,
      # Start a worker by calling: AstraeaVirgo.Worker.start_link(arg)
      # {AstraeaVirgo.Worker, arg}
      # Start Cache (redis)
      {Redix,
       name: :redix,
       host: Application.get_env(:virgo, :cache)[:host],
       port: Application.get_env(:virgo, :cache)[:port],
       password: Application.get_env(:virgo, :cache)[:password],
      },
      AstraeaVirgo.MessageQueue,
      AstraeaVirgo.Thrift.Client,
      # Start Database (mongo)
      # {Mongo,
      #  name: :mongo,
      #  hostname: Application.get_env(:virgo, :database)[:host],
      #  port: Application.get_env(:virgo, :database)[:port],
      #  database: Application.get_env(:virgo, :database)[:db],
      #  username: Application.get_env(:virgo, :database)[:user],
      #  password: Application.get_env(:virgo, :database)[:password],
      #  pool_size: 32, timeout: 5000
      # },
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AstraeaVirgo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AstraeaVirgoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
