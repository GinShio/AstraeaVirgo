defmodule AstraeaVirgoWeb.ProblemController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Problem API without auth:
    - `GET /api/problems`: get problems info (it contains undisclosed questions if perm is admin)
    - `GET /api/problems/<problem_id>`: get the specified problem info
    - `GET /api/problems/<problem_id>/detail`: get the specified problem detail

  Impl Submission API with admin auth:
    - `POST /api/problems`: create problem
    - `PUT /api/problems/<problem_id>`: update problem
    - `DELETE /api/problems/<problem_id>`: delete problem
  """

  @doc """
  Get all problems info API

  API: GET /api/problems

  Response:
    1. return 204 when no probelm exists
    2. return 200 when successfully get problems info, response `AstraeaVirgoWeb.ProblemView.render/2` index.json
    3. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def index(conn, params) do
    with {:ok, params} <- AstraeaVirgo.Validate.ProblemIndexOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Problem.index(params["category"]) do
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, results} ->
        with claims when not is_nil(claims) <- conn |> Guardian.Plug.current_claims(),
             ["admin" | _] <- claims |> Map.get("pem") |> Map.get(:user) do
          conn |>
            put_status(:ok) |>
            render(AstraeaVirgoWeb.ProblemView, "index.json", data: results)
        else
          _ ->
            results = for result <- results, result.public == true, do: result
            case results do
              [] ->
                conn |>
                  put_status(:no_content) |>
                  render(AstraeaVirgoWeb.GenericView, "empty.txt")
              _ ->
                conn |>
                  put_status(:ok) |>
                  render(AstraeaVirgoWeb.ProblemView, "index.json", data: results)
            end
        end
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


  defp check_public(conn, result) do
    with false <- is_nil(result),
         true <- result.public do
      {:ok, result}
    else
      true -> {:ok, nil}
      false ->
        with claims when not is_nil(claims) <- conn |> Guardian.Plug.current_claims(),
             ["admin" | _] <- claims |> Map.get("pem") |> Map.get(:user) do
          {:ok, result}
        else
          _ -> {:ok, nil}
        end
    end
  end

  @doc """
  Get the specified problem info API

  API: GET /api/problems/<problem_id>

  Response:
    1. return 204 when no problem exists or is not public
    2. return 200 when successfully get problem info, response `AstraeaVirgoWeb.ProblemView.render/2` show.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    with {:ok, result} <- AstraeaVirgo.Cache.Problem.show(params["id"]),
         {:ok, nil} <- check_public(conn, result) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ProblemView, "show.json", data: result)
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
  Get the specified problem detail API

  API: GET /api/problems/<problem_id>/detail

  Response:
    1. return 204 when no problem exists or is not public
    2. return 200 when successfully get problem info, response `AstraeaVirgoWeb.ProblemView.render/2` detail.json
    3. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def detail(conn, params) do
    with {:ok, result} <- AstraeaVirgo.Cache.ProblemDetail.show(params["id"]),
         {:ok, nil} <- check_public(conn, result) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ProblemView, "detail.json", data: result)
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

  def create(conn, _params) do
    contest_length = conn |> Plug.Conn.get_req_header("content-length") |> hd |> String.to_integer
    contest_type = conn |> Plug.Conn.get_req_header("content-type") |> hd
    {:ok, body, conn} = Plug.Conn.read_body(conn, length: contest_length)
    with {:ok, mod} <- AstraeaVirgo.Archive.new(contest_type),
         {:ok, list} <- mod.uncompress(body) do
      list |> IO.inspect()
      conn |> render(AstraeaVirgoWeb.GenericView, "empty.txt")
    end
  end

end
