defmodule AstraeaVirgo.Token do
  @moduledoc """
  Impl Token (JWT)

  If the API requires permission, the `Authorization` field in the HTTP Headers will be checked, and the Token type is **Bearer**

  Field:
    - sub: User ID
    - pem: User Permission
      - public token: field pem is `{"default":"public"}`
      - user token: field pem is `{"user":"solo"}`
      - contestant token: field pem is `{"user":"contestant"}`
      - admin token: field pem is `{"user":"admin"}`
    - contest: ID of the contest that the user participated in (if pem is contestant)

  Error Response:
    return 401, response `AstraeaVirgoWeb.ErrorView.render/2` unauthenticated.json / unauthorized.json / invalid_token.json / no_resource_found.json
  """

  @audience "Astraea OnlineJudge Project"
  @issuer Application.get_env(:virgo, :base_url)
  @secret Application.get_env(:virgo, AstraeaVirgoWeb.Endpoint)[:secret_key_base]

  use Guardian,
    issuer: @issuer,
    secret_key: @secret,
    allowed_algos: ["HS256", "HS384", "HS512"],
    secret_fetcher: AstraeaVirgo.Token.SecretFetcher,
    token_verify_module: AstraeaVirgo.Token.Verify,
    permissions: %{
      default: [:public],
      user: [:solo, :contestant, :admin],
    }
  use Guardian.Permissions, encoding: Guardian.Permissions.AtomEncoding

  @public_expiration 300 # 5 mins
  @session_expiration 604800 # 7 days
  @contest_expiration 7200 # 2 hours

  defp get_expiration(), do: @public_expiration
  defp get_expiration(permission) do
    case permission do
      "solo" -> @session_expiration
      "user" -> @session_expiration
      "admin" -> @session_expiration
      "contestant" -> @contest_expiration
      _ -> @public_expiration
    end
  end

  defp get_permission(), do: %{default: [:public]}
  defp get_permission(permission) do
    case permission do
      "solo" -> %{user: [:solo]}
      "user" -> %{user: [:solo]}
      "admin" -> %{user: [:admin]}
      "contestant" -> %{user: [:contestant]}
      _ -> %{default: [:public]}
    end
  end

  def subject_for_token(resource, _claims), do: {:ok, resource}
  def resource_from_claims(claims), do: {:ok, claims["sub"]}
  def build_claims(claims, _reasource, opts) do
    {:ok, claims |> encode_permissions_into_claims!(Keyword.get(opts, :permissions))}
  end

  def get_public_token(email, password) do
    encode_and_sign(
      "154C",
      %{"aud" => @audience},
      ttl: {get_expiration(), :seconds},
      permissions: get_permission(),
      secret: email <> password
    )
  end

  def get_session_token(id, permission \\ "solo", claims \\ %{}) do
    encode_and_sign(
      id,
      claims |> Map.put("aud", @audience),
      ttl: {get_expiration(permission), :seconds},
      permissions: get_permission(permission),
    )
  end

end
