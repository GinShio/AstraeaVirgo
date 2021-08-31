defmodule AstraeaVirgo.Cache.Contests.Problem do
  @moduledoc """
  Implement contest problem operation for cache

  ## Contest problem ID size
  A size of Contest Problem IDs
    - key: `Astraea:Contest:ID:<contest_id>:Problems:Size`
    - type: string

  ## Contest Problem Info
  A key-value mapping the contest problem information
    - Key: `Astraea:Contest:ID:<contest_id>:Problem:ID:<problem_label>`
    - type: hash
    - fields:
      - id
      - label
      - name
      - testcase
      - rgb
  """

  def get_index_key(contest_id), do: "Astraea:Contest:ID:#{contest_id}:Problems:Size"
  def get_show_key(contest_id, problem_label), do: "Astraea:Contest:ID:#{contest_id}:Problem:ID:#{problem_label}"
  @field ["id", "label", "name", "testcase", "rgb"]
  @empty [nil, nil, nil, nil, nil]

  defp get_index_from_db(contest_id) do
    # TODO: get index info from db
    {:ok, nil}
  end

  defp get_info_from_db(contest_id, problem_label) do
    # TODO: get problem info from db
    {:ok, nil}
  end

  defp parse([id, label, name, testcase, rgb]) do
    %{
      id: id,
      label: label,
      name: name,
      testcase: testcase,
      rgb: rgb,
    }
  end

  defp get_index(contest_id) do
    with {:ok, []} <- Redix.command(:redix, ["SMEMBERS", get_index_key(contest_id)]),
         {:ok, nil} <- get_index_from_db(contest_id) do
      {:ok, nil}
    else
      {:ok, _results} = ret -> ret
      {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

  defp get_infos(contest_id, index) do
    infos = for label <- index, reduce: [] do
      acc ->
        with {:ok, @empty} <- Redix.command(:redix, ["HMGET", get_show_key(contest_id, label)] ++ @field),
             {:ok, nil} <- get_info_from_db(contest_id, label) do
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

  def index(contest_id) do
    case get_index(contest_id) do
      {:ok, nil} -> {:ok, nil}
      {:ok, index} -> {:ok, get_infos(contest_id, index)}
      {:error, _reason} = error -> error
    end
  end

  def show(contest_id, problem_label) do
    with {:ok, @empty} <- Redix.command(:redix, ["HMGET", get_show_key(contest_id, problem_label)] ++ @field),
         {:ok, nil} <- get_info_from_db(contest_id, problem_label) do
      {:ok, nil}
    else
      {:ok, result} -> {:ok, parse(result)}
      {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

end
