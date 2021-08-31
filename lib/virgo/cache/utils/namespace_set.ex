defmodule AstraeaVirgo.Cache.Utils.NamespaceSet do
  @moduledoc """
  Interface for Cache Namespace Set
    - Problem
    - ProblemSubject
    - ProblemTestcase

  Generate `index/1` and `show/1` operation for Cache

  Note: Callback functions can be private
  """

  @doc """
  Cache Index Key

  Example:
  ```elixir
  defp get_index_key(namespace), do: "Astraea:Contests:ID:" <> namespace
  ```
  """
  @callback get_index_key(namespace :: String.t()) :: String.t()

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
  @callback get_index_from_db(namespace :: String.t()) :: {:ok, nil | list(String.t())} | {:error, atom() | String.t() | {:database, String.t()}}

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
      defp get_index(namespace) do
        with {:ok, []} <- Redix.command(:redix, ["SMEMBERS", get_index_key(namespace)]),
             {:ok, nil} <- get_index_from_db(namespace) do
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
      @spec index(namespace :: String.t()) ::
      {:ok, nil | list(map())} |
      {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
      @doc """
      Get Infos

      - return `nil` when data is not exists
      - return list of parsed data when successfully
      """
      def index(namespace) do
        case get_index(namespace) do
          {:ok, nil} -> {:ok, nil}
          {:ok, results} -> {:ok, results |> get_infos()}
          {:error, _reason} = error -> error
        end
      end
      @spec show(id :: String.t()) ::
      {:ok, nil | map()} |
      {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
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
