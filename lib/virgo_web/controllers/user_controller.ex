defmodule AstraeaVirgoWeb.UserController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl User API:
    - `POST /api/users`: Register
  """

  @doc """
  Register a new user and automatically log in when successful

  API: POST /api/users

  Request: `AstraeaVirgo.Validate.UserCreateOperation`

  Response:
    1. return 201 when successfully created session, response `AstraeaVirgoWeb.UserView.render/2` create.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 401 when public token is invalid, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    4. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
    5. return 500 when failed to generate token, response `AstraeaVirgoWeb.TokenView.render/2` generate_error.json
  """
  def create(conn, params) do
    # TODO: create user
    create = fn params ->
      {:ok, id} = AstraeaVirgo.Snowflake.create()
      values = for {k, v} <- params, reduce: ["id", id, "permission", "solo"] do
          acc ->
            case k do
              "token" -> acc
              "verify" -> acc
              _ -> acc ++ [k, v]
            end
        end
      Redix.command(:redix, ["HSET", "Astraea:User:ID:" <> id] ++ values)
      {:ok, id}
    end
    with [auth] <- conn |> get_req_header("authorization"),
         <<"Bearer ", token::binary>> <- auth,
         {:ok, _params} <- AstraeaVirgo.Validate.UserCreateOperation.run(params |> Map.put("token", token)),
         {:ok, id} <- create.(params) do
      case AstraeaVirgo.Token.get_session_token(id, "solo") do
        {:ok, token, _claims} ->
          conn |>
            put_status(:created) |>
            render(AstraeaVirgoWeb.UserView, "create.json", token: token)
        {:error, reason} ->
          conn |>
            put_status(:internal_server_error) |>
            render(AstraeaVirgoWeb.TokenView, "generate_error.json", reason: reason)
      end
    else
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {type, reason}} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: type, reason: reason)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :internal, reason: reason)
      _ ->
        conn |>
          put_status(:unauthorized) |>
          render(AstraeaVirgoWeb.ErrorView, "unauthorized.json", reason: :bearer_token_not_exists)
    end
  end

end
