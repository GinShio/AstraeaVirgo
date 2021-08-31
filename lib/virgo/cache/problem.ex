defmodule AstraeaVirgo.Cache.Problem do
  @moduledoc """
  Implement Problem operation for cache

  ## Problem ID set
  A collection of Problem IDs, used to cache the IDs of existing problems.
    - key: `Astraea:Problems:Category:<category_id>`
    - type: set

  ## Problem Info
  A key-value mapping the problem information, key is problem id
    - Key: `Astraea:Problem:ID:<problem_id>`
    - type: hash
    - fields:
      - id
      - name
      - category
      - ordinal
      - testcase
      - lock
      - public
      - total
      - ac
  """

  use AstraeaVirgo.Cache.Utils.NamespaceSet

  def get_index_key(category), do: "Astraea:Problems:Category:#{category}"
  def get_show_key(id), do: "Astraea:Problem:ID:#{id}"
  defp get_field_name(), do: ["id", "name", "category", "ordinal", "testcase", "lock", "public", "total", "ac"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil, nil, nil, nil, nil]

  defp get_index_from_db(namespace) do
    # TODO: request index from DB
    {:ok, nil}
  end

  defp get_info_from_db(id) do
    # TODO: request problem info from DB
    {:ok, nil}
  end

  defp parse([id, name, category, ordinal, testcase, lock, public, total, ac]) do
    %{
      id: id,
      name: name,
      category: category,
      ordinal: String.to_integer(ordinal),
      testcase: String.to_integer(testcase),
      lock: String.to_atom(lock),
      public: String.to_atom(public),
      total: String.to_integer(total),
      ac: String.to_integer(ac),
    }
  end
 end
