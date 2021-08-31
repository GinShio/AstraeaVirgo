# defmodule AstraeaVirgo.Thrift do
#   @pool_size 5

#   @host Application.get_env(:virgo, :rpc)[:host]
#   @port Application.get_env(:virgo, :rpc)[:port]

#   def child_spec(_args) do
#     children = for index <- 0..(@pool_size - 1) do
#       Supervisor.child_spec(
#         {AstraeaVirgo.Thrift.Client,
#          name: :"thrift_client_#{index}", host: @host, port: @port, index: index},
#         id: {AstraeaVirgo.Thrift.Client, index})
#     end
#     %{
#       id: AstraeaVirgoThriftSupervisor,
#       type: :supervisor,
#       start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
#     }
#   end

#   def run(func, params) do
#     AstraeaVirgo.Thrift.Client.run(:"thrift_client_#{random_index()}", func, params)
#   end

#   defp random_index(), do: Enum.random(0..@pool_size - 1)

# end
