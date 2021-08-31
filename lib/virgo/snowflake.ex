defmodule AstraeaVirgo.Snowflake do

  @timeout 64

  defp create(timeout) do
    case Snowflake.next_id() do
      {:ok, snowflake} -> {:ok, snowflake |> Integer.to_string(32)}
      _ ->
        if timeout > 2048 do
          {:error, :backwards_clock}
        else
          Process.sleep(timeout)
          create(timeout * 2)
        end
    end
  end

  @doc """
  Create Snowflake ID

  sleep some time (64, 128, 256, 512, 1024, 2048) when backward clock, 4032 ms in total
  """
  def create(), do: create(@timeout)

end
