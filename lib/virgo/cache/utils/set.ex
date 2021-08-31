defmodule AstraeaVirgo.Cache.Utils.Set do
  @moduledoc """
  Interface for Cache Generic Set
    - Contest
    - Language
    - Organization

  Generate `exist?/1`, `index/0` and `show/1` operation for Cache

  Note: Callback functions can be private
  """

  @doc """
  Cache Index Key

  Example:
  ```elixir
  defp get_index_key(), do: "Astraea:Contests"
  ```
  """
  @callback get_index_key() :: String.t()

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
  Get Index from Database
  """
  @callback get_index_from_db() :: {:ok, nil | list(String.t())} | {:error, atom() | String.t() | {:database, String.t()}}

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
      defp get_index() do
        with {:ok, []} <- Redix.command(:redix, ["SMEMBERS", get_index_key()]),
             {:ok, nil} <- get_index_from_db() do
          {:ok, nil}
        else
          {:ok, _results} = ret -> ret
          {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
        end
      end
      defp get_infos(index) do
        empty = get_empty_value()
        infos = for id <- index, reduce: [] do
          acc ->
            with {:ok, ^empty} <- Redix.command(:redix, ["HMGET", get_show_key(id)] ++ get_field_name()),
                 {:ok, nil} <- get_info_from_db(id) do
              acc
            else
              {:ok, result} -> [parse(result) | acc]
              {:error, _reason} -> acc
            end
        end
        case infos do
          [] -> nil
          _ -> infos
        end
      end
      @spec exist?(id :: String.t()) :: boolean() | {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
      @doc """
      Check ID exist
      """
      def exist?(id) do
        case get_index() do
          {:ok, nil} -> false
          {:ok, result} -> id in result
          {:error, _reason} = error -> error
        end
      end
      @spec index() :: {:ok, nil | map()} | {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
      @doc """
      Get Infos

        - return `nil` when data is not exists
        - return list of parsed data when successfully
      """
      def index() do
        case get_index() do
          {:ok, nil} -> {:ok, nil}
          {:ok, results} -> {:ok, results |> get_infos()}
          {:error, _reason} = error -> error
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
             true <- exist?(id),
             {:ok, nil} <- get_info_from_db(id) do
          {:ok, nil}
        else
          false -> {:ok, nil}
          {:ok, result} -> {:ok, parse(result)}
          {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
        end
      end
    end
  end

end
