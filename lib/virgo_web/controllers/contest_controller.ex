defmodule AstraeaVirgoWeb.ContestController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Contest API without auth:
    - `GET /api/contests`: get all contests info
    - `GET /api/contests/<contest_id>`: get the specified contest info

  Impl Contest API with admin auth:
    - `POST /api/contests`: create a contest
    - `DELETE /api/contests/<contest_id>`: delete the specified contest
  """

  @doc """
  Get all contest info API

  API: GET /api/contests

  Response:
    1. return 204 when no contest exists
    2. return 200 when successfully get contests info, response `AstraeaVirgoWeb.ContestView.render/2` index.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def index(conn, _params) do
    case AstraeaVirgo.Cache.Contest.index() do
      {:ok, nil} ->
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, results} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ContestView, "index.json", data: results)
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
  Get the specified contest info API

  API: GET /api/contests/<contest_id>

  Response:
    1. return 204 when no contest exists
    2. return 200 when successfully get contest info, response `AstraeaVirgoWeb.ContestView.render/2` show.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    case AstraeaVirgo.Cache.Contest.show(params["id"]) do
      {:ok, nil} ->
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ContestView, "show.json", data: result)
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
  Create Contest API

  API: POST /api/contests

  Request: `AstraeaVirgo.Validate.ContestSettingOperation`

  Response:
    1. return 201 when successfully created contest, response `AstraeaVirgoWeb.ContestView.render/2` create.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def create(conn, params) do
    # TODO: create contest
    create = fn params ->
      values = for {k, v} <- params, reduce: [] do
          acc ->
            case k do
              "logo" -> acc ++ [k, Jason.encode!(v)]
              _ -> acc ++ [k, v]
            end
      end
      Redix.pipeline(:redix,
        [
          ["SADD", "Astraea:Contests", params["id"]],
          ["HSET", "Astraea:Contest:ID:" <> params["id"]] ++ values
        ]
      )
    end
    with {:ok, {:not_exist, params}} <- AstraeaVirgo.Validate.ContestSettingOperation.run(params),
         {:ok, _result} <- create.(params) do
        conn |>
          put_status(:created) |>
          render(AstraeaVirgoWeb.ContestView, "create.json", contest_id: params["id"])
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
  Delete Contest API

  API: DELETE /api/contests/<contest_id>

  Response:
    1. return 200 when successfully deleted contest, response `AstraeaVirgoWeb.GenericView.render/2` empty.txt
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def delete(conn, params) do
    # TODO: delete contest
    delete = fn id ->
      Redix.pipeline(:redix,
        [
          ["SREM", "Astraea:Contests", id],
          ["DEL", "Astraea:Contest:ID:" <> id]
        ]
      )
    end
    with {:ok, _params} <- params |> Map.put("contest_id", params["id"]) |> AstraeaVirgo.Validate.ContestPathOperation.run(),
         {:ok, _result} <- delete.(params["id"]) do
      conn |>
        put_status(:ok) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
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
    end
  end

end
