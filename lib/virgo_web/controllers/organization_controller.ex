defmodule AstraeaVirgoWeb.OrganizationController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Organization API without auth:
    - `GET /api/organizations`: get organizations info
    - `GET /api/organizations/<organization_id>`: get the specified organization info

  Impl Organization API with admin auth:
    - `POST /api/organizations`: create a organization
    - `PUT /api/organizations/<organization_id>` update the specified organization
    - `DELETE /api/organizations/<organization_id>`: delete the specified organization
  """

  @doc """
  Get all organization info API

  API: GET /api/organizations

  Response:
    1. return 204 when no organization exists
    2. return 200 when successfully get organizations info, response `AstraeaVirgoWeb.OrganizationView.render/2` index.json
    3. return 500 when returned error by cache or database, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def index(conn, _params) do
    case AstraeaVirgo.Cache.Organization.index() do
      {:ok, nil} ->
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, results} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.OrganizationView, "index.json", data: results)
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
  Get the specified organization info API

  API: GET /api/organizations/<organization_id>

  Response:
    1. return 204 when no organization exists
    2. return 200 when successfully get organization info, response `AstraeaVirgoWeb.OrganizationView.render/2` show.json
    3. return 500 when returned error by cache or database, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    case AstraeaVirgo.Cache.Organization.show(params["id"]) do
      {:ok, nil} ->
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.OrganizationView, "show.json", data: result)
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
  Create organization API

  API: POST /api/organizations

  Request: `AstraeaVirgo.Validate.OrganizationSettingOperation`

  Response:
    1. return 201 when successfully created organization, response `AstraeaVirgoWeb.OrganizationView.render/2` create.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def create(conn, params) do
    # TODO: create organization
    create = fn (params) ->
      values = for {k, v} <- params, reduce: [] do
          acc ->
            case k do
              "logo" -> acc ++ [k, Jason.encode!(v)]
              _ -> acc ++ [k, v]
            end
      end
      Redix.pipeline(:redix,
        [
          ["SADD", "Astraea:Organizations", params["id"]],
          ["HSET", "Astraea:Organization:ID:" <> params["id"]] ++ values
        ]
      )
    end
    with {:ok, {:not_exist, params}} <- AstraeaVirgo.Validate.OrganizationSettingOperation.run(params),
         {:ok, _result} <- create.(params) do
      conn |>
        put_status(:created) |>
        render(AstraeaVirgoWeb.OrganizationView, "create.json", organization_id: params["id"])
    else
      {:ok, {:exist, _params}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: %{"id" => ["exists."]})
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
    end
  end

  @doc """
  Update the specified organization API

  API: PUT /api/organizations/<organization_id>

  Request: `AstraeaVirgo.Validate.OrganizationSettingOperation`

  Note: request field "id" is from UTL path variable "organization_id"

  Response:
    1. return 200 when successfully updated organization, response `AstraeaVirgoWeb.OrganizationView.render/2` show.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def update(conn, params) do
    # TODO: update organization
    update = fn params ->
      values = for {k, v} <- params, reduce: [] do
        acc -> acc ++ [k, to_string(v)]
      end
      Redix.pipeline(:redix,
        [
          ["SADD", "Astraea:Organizations", params["id"]],
          ["HSET", "Astraea:Organization:ID:" <> params["id"]] ++ values
        ]
      )
      AstraeaVirgo.Cache.Organization.show(params["id"])
    end
    with {:ok, {:exist, params}} <- AstraeaVirgo.Validate.OrganizationSettingOperation.run(params),
         {:ok, data} <- update.(params) do
      conn |>
        put_status(:ok) |>
        render(AstraeaVirgoWeb.OrganizationView, "show.json", data: data)
    else
      {:ok, {:not_exist, _params}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: %{"id" => ["not exists."]})
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
    end
  end

  @doc """
  Delete the specified organization API

  API: DELETE /api/organizations/<organization_id>

  Response:
    1. return 200 when successfully deleted organization, response `AstraeaVirgoWeb.GenericView.render/2` empty.txt
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when returned error by cache or database, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def delete(conn, params) do
    # TODO: delete organization
    delete = fn id ->
      Redix.pipeline(:redix,
        [
          ["SREM", "Astraea:Organizations", id],
          ["DEL", "Astraea:Organization:ID:" <> id]
        ]
      )
    end
    with false <- params["id"] =~ ~r/^[A-Z][A-Z]$/,
         {:ok, _params} <- AstraeaVirgo.Validate.OrganizationPathOperation.run(params),
         {:ok, _result} <- delete.(params["id"]) do
      conn |>
        put_status(:ok) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      true ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: %{"id" => ["is reserved."]})
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
    end
  end

end
