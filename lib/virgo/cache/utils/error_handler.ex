defmodule AstraeaVirgo.Cache.Utils.ErrorHandler do
  @moduledoc false

  @doc """
  Parse Cache Error
  Return:
    - `{:ok, nil}`: Wrong Type means that Object is not exist
    - `{:error, {:cache, message}}`: Error Connection or returned by Cache
    - `{:error, {:database, message}}`: Error Connection or returned by Database
    - `{:error, String.t()}`: Internal Error
  """
  def parse({:error, %Redix.Error{} = reason}) do
    case reason.message |> binary_part(0, 9) do
      "WRONGTYPE" -> {:ok, nil}
      _ -> {:error, {:cache, reason.message}}
    end
  end
  def parse({:error, %Redix.ConnectionError{} = reason}), do: {:error, {:cache, Redix.ConnectionError.message(reason)}}
  def parse({:error, {:cache, _message}} = error), do: error
  def parse({:error, {:database, _message}} = error), do: error
  def parse({:error, reason}), do: {:error, to_string(reason)}
end
