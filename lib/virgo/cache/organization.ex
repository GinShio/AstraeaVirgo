defmodule AstraeaVirgo.Cache.Organization do
  @moduledoc """
  Implement Organization operation for cache

  ## Organization ID set
  A collection of Organization IDs, used to cache the IDs of existing organizations.
    - key: `Astraea:Organizations`
    - type: set

  ## Contest Info
  A key-value mapping the organization information, key is organization id
    - Key: `Astraea:Language:ID:<organization_id>`
    - type: hash
    - fields:
      - id
      - name
      - formal_name (optional)
      - url (optional)
      - logo (optional)
  """

  use AstraeaVirgo.Cache.Utils.Set

  def get_index_key(), do: "Astraea:Organizations"
  def get_show_key(id), do: "Astraea:Organization:ID:#{id}"
  defp get_field_name(), do: ["id", "name", "formal_name", "url", "logo"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil]

  defp get_index_from_db() do
    # TODO: request index from DB
    {:ok, nil}
  end

  defp get_info_from_db(id) do
    # TODO: request organization info from DB
    {:ok, nil}
  end

  defp parse([id, name, formal_name, url, logo]) do
    %{
      id: id,
      name: name,
    } |>
      AstraeaVirgo.Cache.Utils.Parse.formal_name(formal_name) |>
      AstraeaVirgo.Cache.Utils.Parse.url(url) |>
      AstraeaVirgo.Cache.Utils.Parse.file(:logo, logo)
  end

end
