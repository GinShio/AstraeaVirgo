defmodule AstraeaVirgo.Cache.Submission do
  @moduledoc """
  Implement submission operation for cache

  ## Submission ID list
  A list of Submission IDs
    - key: `Astraea:User:ID:<user_id>:Submissions`
    - type: list

  ## Submission Info
  A key-value mapping the submission information
    - Key: `Astraea:Submission:ID:<submission_id>`
    - type: hash
    - fields:
      - id
      - language
      - problem
      - submitter
      - time
      - judgement
      - code
      - message (optional)
      - score (reserver)
  """

  def get_index_key(id), do: "Astraea:User:ID:#{id}:Submissions"
  def get_show_key(id), do: "Astraea:Submission:ID:#{id}"
  @field ["id", "language", "problem", "submitter", "time", "judgement"]
  @empty [nil, nil, nil, nil, nil, nil]

  defp get_index_from_db(id) do
    # TODO: request index from DB
    {:ok, nil}
  end

  defp get_info_from_db(id) do
    # TODO: request contest info from DB
    {:ok, nil}
  end

  defp parse([id, language, problem, submitter, time, judgement]) do
    %{
      id: id,
      language: language,
      problem: problem,
      submitter: submitter,
      time: time,
      judgement: judgement,
    }
  end

  defp get_index(id) do
    with {:ok, []} <- Redix.command(:redix, ["LRANGE", get_index_key(id), "0", "49"]),
         {:ok, nil} <- get_index_from_db(id) do
      {:ok, nil}
    else
      {:ok, _results} = ret -> ret
      {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

  defp get_infos(index) do
    infos = for id <- index, reduce: [] do
      acc ->
        with {:ok, @empty} <- Redix.command(:redix, ["HMGET", get_show_key(id)] ++ @field),
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

  @spec index(id :: String.t()) :: {:ok, nil | map()} | {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
  @doc """
  Get Infos

  - return `nil` when data is not exists
  - return list of parsed data when successfully
  """
  def index(id) do
    case get_index(id) do
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
    with {:ok, @empty} <- Redix.command(:redix, ["HMGET", get_show_key(id)] ++ @field),
         {:ok, nil} <- get_info_from_db(id) do
      {:ok, nil}
    else
      {:ok, result} -> {:ok, parse(result)}
    {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

end
