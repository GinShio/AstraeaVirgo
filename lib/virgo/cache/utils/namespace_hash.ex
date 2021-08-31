defmodule AstraeaVirgo.Cache.Utils.NamespaceHash do
  @moduledoc """
  Interface for Cache Namespace Hash
    - Contest.Judgement

  Generate `show/2` operation for Cache

  Note: Callback functions can be private
  """

  @doc """
  Cache Show Key
  """
  @callback get_show_key(namespace :: String.t(), id :: String.t()) :: String.t()

  @doc """
  Cache Field name of info

  Example:
  ```elixir
  defp get_field_name(), do: ["id", "name", "extensions", "time", "memory"]
  ```
  """
  @callback get_field_name() :: list(String.t())

  @doc """
  Get empty info from Cache

  return list of nil, length is the same as the field name list

  Example:
  ```elixir
  defp get_empty_value(), do: [nil, nil, nil, nil, nil]
  ```
  """
  @callback get_empty_value() :: list(nil)

  @doc """
  Parse Cache Fields
  """
  @callback parse(data :: list()) :: map()

  defmacro __using__(_opts) do
    quote do
      @spec show(namespace :: String.t(), id :: String.t()) ::
      {:ok, nil | map()} |
      {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
      @doc """
      Get Specified Info

        - return `nil` when data is not exists
        - return parsed data when successfully
      """
      def show(namespace, id) do
        empty = get_empty_value()
        case Redix.command(:redix, ["HMGET", get_show_key(namespace, id)] ++ get_field_name()) do
          {:ok, ^empty} -> {:ok, nil}
          {:ok, result} -> {:ok, parse(result)}
          {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
        end
      end
    end
  end

end
