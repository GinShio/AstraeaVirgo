defmodule AstraeaVirgo.Cache.Contest do
  @moduledoc """
  Implement contest operation for cache

  ## Contest ID set
  A collection of contest IDs, used to cache the IDs of existing contests.
    - key: `Astraea:Contests`
    - type: set

  ## Contest Info
  A key-value mapping the contest information, key is contest id
    - Key: `Astraea:Contest:ID:<contest_id>`
    - type: hash
    - fields:
      - id
      - name
      - formal_name (optional)
      - public
      - anonymous
      - start
      - duration
      - freeze
      - penalty
      - logo (optional)
  """

  use AstraeaVirgo.Cache.Utils.Set

  def get_index_key(), do: "Astraea:Contests"
  def get_show_key(id), do: "Astraea:Contest:ID:#{id}"
  defp get_field_name(), do: ["id", "name", "formal_name", "public", "anonymous", "start", "duration", "freeze", "penalty", "logo"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

  defp get_index_from_db() do
    # TODO: request index from DB
    {:ok, nil}
  end

  defp get_info_from_db(id) do
    # TODO: request contest info from DB
    {:ok, nil}
  end

  defp parse([id, name, formal_name, public, anonymous, start, duration, freeze, penalty, logo]) do
    %{
      id: id,
      name: name,
      public: String.to_atom(public),
      anonymous: String.to_atom(anonymous),
      start_time: start,
      duration: String.to_integer(duration),
      scoreboard_freeze_duration: String.to_integer(freeze),
      penalty_time: String.to_integer(penalty),
    } |>
      AstraeaVirgo.Cache.Utils.Parse.formal_name(formal_name) |>
      AstraeaVirgo.Cache.Utils.Parse.file(:logo, logo)
  end

end
