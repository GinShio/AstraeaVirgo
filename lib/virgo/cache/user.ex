defmodule AstraeaVirgo.Cache.User do
  @moduledoc """
  Implement user operation for cache

  ## User Info
  A key-value mapping the User information, key is user id
    - Key: `Astraea:User:ID:<user_id>`
    - type: hash
    - fields:
      - id
      - username
      - formal_name (optional)
      - password
      - permission
      - contest (optional)
  """

  use AstraeaVirgo.Cache.Utils.Hash

  def get_show_key(id), do: "Astraea:User:ID:#{id}"
  defp get_field_name(), do: ["id", "username", "formal_name", "password", "permission", "contest"]
  defp get_empty_value(), do: [nil, nil, nil, nil, nil, nil]

  defp get_info_from_db(id) do
    # TODO: request user info from DB
    {:ok, nil}
  end

  defp parse([id, username, formal_name, password, permission, contest]) do
    %{
      id: id,
      username: username,
      password: password,
      permission: permission,
    } |>
      AstraeaVirgo.Cache.Utils.Parse.formal_name(formal_name) |>
      AstraeaVirgo.Cache.Utils.Parse.contest(contest)
  end

end
