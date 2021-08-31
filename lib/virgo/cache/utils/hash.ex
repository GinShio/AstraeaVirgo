defmodule AstraeaVirgo.Cache.Utils.Hash do
  @moduledoc """
  Interface for Cache Generic Hash
    - User
    - Judgement

  Generate `exist?/1` and `show/1` operation for Cache

  Note: Callback functions can be private
  """

  @doc """
  Cache Show Key
  """
  @callback get_show_key(id :: String.t()) :: String.t()

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
  Get the specified Info from Database
  """
  @callback get_info_from_db(id :: String.t()) :: {:ok, nil | list()} | {:error, atom() | String.t() | {:database, String.t()}}

  @doc """
  Parse Cache Fields
  """
  @callback parse(data :: list()) :: map()

  defmacro __using__(_opts) do
    quote do
      @spec exist?(id :: String.t()) :: boolean() | {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
      @doc """
      Check ID exist
      """
      def exist?(id) do
        empty = get_empty_value()
        with {:ok, ^empty} <- Redix.command(:redix, ["HMGET", get_show_key(id)] ++ get_field_name()),
             {:ok, nil} <- get_info_from_db(id) do
          false
        else
          {:ok, _result} -> true
          {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
        end
      end
      @spec show(id :: String.t()) :: {:ok, nil | map()} | {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
      @doc """
      Get Specified Info

        - return `nil` when data is not exists
        - return parsed data when successfully
      """
      def show(id) do
        empty = get_empty_value()
        with {:ok, ^empty} <- Redix.command(:redix, ["HMGET", get_show_key(id)] ++ get_field_name()),
             {:ok, nil} <- get_info_from_db(id) do
          {:ok, nil}
        else
          {:ok, result} -> {:ok, parse(result)}
          {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
        end
      end
    end
  end

end
