defmodule AstraeaVirgoWeb.LanguageController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Language API without auth:
    - `GET /api/languages`: get languages info
    - `GET /api/languages/<language_id>`: get the specified language info

  Impl Language API with admin auth:
    - `POST /api/languages`: create a language
    - `PUT /api/languages/<language_id>` update the specified language
    - `DELETE /api/languages/<language_id>`: delete the specified language
  """

  @doc """
  Get all language info API

  API: GET /api/languages

  Response:
    1. return 204 when no language exists
    2. return 200 when successfully get languages info, response `AstraeaVirgoWeb.LanguageView.render/2` index.json
    3. return 500 when returned error by cache or database, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def index(conn, _params) do
    case AstraeaVirgo.Cache.Language.index() do
      {:ok, nil} ->
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, results} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.LanguageView, "index.json", data: results)
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
  Get the specified language info API

  API: GET /api/languages/<language_id>

  Response:
    1. return 204 when no language exists
    2. return 200 when successfully get language info, response `AstraeaVirgoWeb.LanguageView.render/2` show.json
    3. return 500 when returned error by cache or database, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    case AstraeaVirgo.Cache.Language.show(params["id"]) do
      {:ok, nil} ->
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.LanguageView, "show.json", data: result)
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
  Create Language API

  API: POST /api/languages

  Request: `AstraeaVirgo.Validate.LanguageSettingOperation`

  Response:
    1. return 201 when successfully created language, response `AstraeaVirgoWeb.LanguageView.render/2` create.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def create(conn, params) do
    # TODO: create language
    create = fn (params) ->
      values = for {k, v} <- params, reduce: [] do
          acc ->
            case k do
              "extensions" -> acc ++ [k, Jason.encode!(v)]
              _ -> acc ++ [k, v]
            end
        end
      Redix.pipeline(:redix,
        [
          ["SADD", "Astraea:Languages", params["id"]],
          ["HSET", "Astraea:Language:ID:" <> params["id"]] ++ values
        ]
      )
    end
    with {:ok, {:not_exist, params}} <- AstraeaVirgo.Validate.LanguageSettingOperation.run(params),
         true <- Map.get(params, "compile_script") !== nil and Map.get(params, "run_script") !== nil,
         {:ok, _result} <- create.(params) do
      conn |>
        put_status(:created) |>
        render(AstraeaVirgoWeb.LanguageView, "create.json", language_id: params["id"])
    else
      false ->
        fields = %{
          "compile_script" => ["maybe not exists."],
          "run_script" => ["maybe not exists."],
        }
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
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
  Update the specified language info API

  API: PUT /api/languages/<language_id>

  Request: `AstraeaVirgo.Validate.LanguageSettingOperation`

  Note: request field "id" is from UTL path variable "language_id"

  Response:
    1. return 200 when successfully updated language, response `AstraeaVirgoWeb.LanguageView.render/2` show.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def update(conn, params) do
    # TODO: update language
    update = fn params ->
      values = for {k, v} <- params, reduce: [] do
          acc ->
            case k do
              "extensions" -> acc ++ [k, Jason.encode!(v)]
              _ -> acc ++ [k, v]
            end
        end
      Redix.pipeline(:redix,
        [
          ["SADD", "Astraea:Languages", params["id"]],
          ["HSET", "Astraea:Language:ID:" <> params["id"]] ++ values
        ]
      )
      AstraeaVirgo.Cache.Language.show(params["id"])
    end
    with {:ok, {:exist, params}} <- AstraeaVirgo.Validate.LanguageSettingOperation.run(params),
         {:ok, data} <- update.(params) do
      conn |>
        put_status(:ok) |>
        render(AstraeaVirgoWeb.LanguageView, "show.json", data: data)
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
  Delete the specified language API

  API: DELETE /api/languages/<language_id>

  Response:
    1. return 200 when successfully deleted language, response `AstraeaVirgoWeb.GenericView.render/2` empty.txt
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when returned error by cache or database, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def delete(conn, params) do
    # TODO: delete language
    delete = fn id ->
      Redix.pipeline(:redix,
        [
          ["SREM", "Astraea:Languages", id],
          ["DEL", "Astraea:Language:ID:" <> id]
        ]
      )
    end
    with {:ok, _params} <- AstraeaVirgo.Validate.LanguagePathOperation.run(params),
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
