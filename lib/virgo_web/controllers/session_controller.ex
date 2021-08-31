defmodule AstraeaVirgoWeb.SessionController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Session API:
    - `POST /api/sessions`: Login
    - `PUT /api/sessions/<session-id>`: refresh session token
  """

  @doc """
  Login API

  API: POST /api/sessions

  Request: `AstraeaVirgo.Validate.SessionCreateOperation`

  Response:
    1. return 201 when successfully created session, response `AstraeaVirgoWeb.TokenView.render/2` create.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 401 when account or password error, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    4. return 500 when failed to generate token, response `AstraeaVirgoWeb.TokenView.render/2` generate_error.json
    5. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def create(conn, params) do
    case AstraeaVirgo.Validate.SessionCreateOperation.run(params) do
      {:ok, params} ->
        case AstraeaVirgo.Token.get_session_token(params["id"], params["pem"]) do
          {:ok, token, _claims} ->
            conn |>
              put_status(:created) |>
              render(AstraeaVirgoWeb.TokenView, "create.json", token: token)
          {:error, reason} ->
            conn |>
              put_status(:internal_server_error) |>
              render(AstraeaVirgoWeb.TokenView, "generate_error.json", reason: reason)
        end
      {:error, :bad_request} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "unauthorized.json", reason: :account_or_password_incorrect)
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:unauthorized) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {type, reason}} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: type, reason: reason)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :internal, reason: reason)
    end
  end

  @doc """
  Request New Session Token

  API: PUT /api/sessions/<user_id>

  Response:
    1. return 201 when successfully create session, response `AstraeaVirgoWeb.TokenView.render/2` create.json
    2. return 401 when ID and Token are inconsistent, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    3. return 500 when failed to generate token, response `AstraeaVirgoWeb.TokenView.render/2` generate_error.json
    4. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def update(conn, params) do
    claims = conn |> Guardian.Plug.current_claims()
    with true <- params["id"] === claims["sub"],
         {:ok, user} <- AstraeaVirgo.Cache.User.show(claims["sub"]) do
      case AstraeaVirgo.Token.get_session_token(user.id, user.permission) do
        {:ok, token, _claims} ->
          conn |>
            put_status(:created) |>
            render(AstraeaVirgoWeb.TokenView, "create.json", token: token)
        {:error, reason} ->
          conn |>
            put_status(:internal_server_error) |>
            render(AstraeaVirgoWeb.TokenView, "generate_error.json", reason: reason)
      end
    else
      false ->
        conn |>
          put_status(:unauthorized) |>
          render(AstraeaVirgoWeb.ErrorView, "unauthorized.json", reason: :inconsistent)
      {:error, {type, reason}} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: type, reason: reason)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :internal, reason: reason)
    end
  end

end
