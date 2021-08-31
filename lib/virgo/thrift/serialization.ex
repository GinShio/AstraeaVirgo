defmodule AstraeaVirgo.Thrift.Serialization do

  def serialization(data, mod, struct) do
    {:ok, trans} = :thrift_membuffer_transport.new()
    {:ok, proto} = :thrift_compact_protocol.new(trans)
    {proto, :ok} = proto |>
      :thrift_protocol.write({struct |> mod.struct_info(), data})
    {_trans, {:ok, bin}} = proto |>
      elem(2) |> elem(1) |>
      :thrift_transport.read(536870912)
    bin
  end

  def unserialization(bin, mod, struct) do
    {:ok, trans} = :thrift_membuffer_transport.new()
    {trans, :ok} = :thrift_transport.write(trans, bin)
    {:ok, proto} = :thrift_compact_protocol.new(trans)
    {_proto, {:ok, data}} = proto |>
      :thrift_protocol.read(struct |> mod.struct_info())
    data
  end

end
