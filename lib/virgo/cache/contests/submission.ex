defmodule AstraeaVirgo.Cache.Contests.Submission do
  @moduledoc """
  Implement contest submission operation for cache

  ## Contest Submission ID sorted set
  A sorted set of Contest Submission IDs
    - key: `Astraea:Contest:ID:<contest_id>:Submissions`
    - type: sorted set
    - score: unix millisecond timestamp
    - value: submission ID

  ## Submission Info
  A key-value mapping the submission information, aliases `AstraeaVirgo.Cache.Submission`
    - Key: `Astraea:Submission:ID:<submission_id>`
    - type: hash
    - fields:
      - id
      - language
      - problem
      - submitter
      - time
      - judgement
      - contest
      - code
      - message (optional)
      - score (reserver)
  """

  def get_index_key(contest_id), do: "Astraea:Contest:ID:#{contest_id}:Submissions"
  def get_show_key(submission_id), do: "Astraea:Submission:ID:#{submission_id}"

  @field ["id", "language", "problem", "submitter", "time", "judgement", "contest"]
  @empty [nil, nil, nil, nil, nil, nil, nil]

  defp parse([id, language, problem, submitter, time, judgement, contest]) do
    %{
      id: id,
      language: language,
      problem: problem,
      submitter: submitter,
      time: time,
      judgement: judgement,
      contest: contest,
    }
  end

  defp get_index(contest_id, now) do
    case Redix.command(:redix, ["ZRANGE", get_index_key(contest_id), now, "+inf"]) do
      {:ok, []} -> {:ok, nil}
      {:ok, _results} = ret -> ret
      {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

  defp get_infos(index) do
    infos = for id <- index, reduce: [] do
      acc ->
        case Redix.command(:redix, ["HMGET", get_show_key(id)] ++ @field) do
          {:ok, @empty} -> acc
          {:ok, result} -> [parse(result) | acc]
          {:error, _reason} -> acc
        end
    end
    case infos do
      [] -> nil
      _ -> infos
    end
  end

  @spec index(contest_id :: String.t(), now :: String.t()) ::
  {:ok, nil | list(map())} |
  {:error, atom() | String.t() | {:cache, String.t()} | {:database, String.t()}}
  @doc """
  Get Infos

  - return `nil` when data is not exists
  - return list of parsed data when successfully
  """
  def index(contest_id, now) do
    case get_index(contest_id, now) do
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
    case Redix.command(:redix, ["HMGET", get_show_key(id)] ++ @field) do
      {:ok, @empty} -> {:ok, nil}
      {:ok, result} -> {:ok, parse(result)}
      {:error, _reason} = error -> AstraeaVirgo.Cache.Utils.ErrorHandler.parse(error)
    end
  end

end
