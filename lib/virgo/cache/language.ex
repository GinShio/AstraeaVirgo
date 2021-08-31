defmodule AstraeaVirgo.Cache.Language do
  @moduledoc """
  Implement language operation for cache

  ## Languaeg ID set
  A collection of language IDs, used to cache the IDs of existing languages.
    - key: `Astraea:Languages`
    - type: set

  ## Contest Info
  A key-value mapping the language information, key is language id
    - Key: `Astraea:Language:ID:<language_id>`
    - type: hash
    - fields:
      - id
      - name
      - extensions (encode to json)
      - time_multiplier
      - mem_multiplier
  """

  use AstraeaVirgo.Cache.Utils.Set

  def get_index_key(), do: "Astraea:Languages"
  def get_show_key(id), do: "Astraea:Language:ID:#{id}"
  defp get_field_name(), do: ["id", "name", "extensions", "time_multiplier", "mem_multiplier"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil]

  defp get_index_from_db() do
    # TODO: request index from DB
    {:ok, nil}
  end

  defp get_info_from_db(id) do
    # TODO: request language info from DB
    {:ok, nil}
  end

  defp parse([id, name, extensions, time_multiplier, mem_multiplier]) do
    %{
      id: id,
      name: name,
      extensions: Jason.decode!(extensions),
      time_multiplier: String.to_float(time_multiplier),
      mem_multiplier: String.to_float(mem_multiplier),
    }
  end

end
