defmodule AstraeaVirgo.Cache.ProblemDetail do
  @moduledoc """
  Implement ProblemDetail operation for cache

  ## Problem Detail
  A key-value mapping the problem detail, key is problem id
    - Key: `Astraea:Problem:ID:<problem_id>:Detail`
    - type: hash
    - fields:
      - id
      - public
      - detail
      - mime
      - time_limit
      - memory_limit
  """

  use AstraeaVirgo.Cache.Utils.Hash

  def get_show_key(id), do: "Astraea:Problem:ID:#{id}:Detail"
  defp get_field_name(), do: ["id", "public", "detail", "mime", "time_limit", "memory_limit"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil, nil]

  defp get_info_from_db(id) do
    # TODO: request problem info from DB
    {:ok, nil}
  end

  defp parse([id, public, detail, mime, time_limit, memory_limit]) do
    %{
      id: id,
      public: String.to_atom(public),
      detail: detail,
      mime: mime,
      time_limit: String.to_integer(time_limit),
      memory_limit: String.to_integer(memory_limit),
    }
  end

end
