defmodule AstraeaVirgoWeb.Contests.SubmissionController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Contest Submission API without auth:
    - `GET /api/contests/<contest_id>/submissions`: get submissions info of specified contest
    - `GET /api/contests/<contest_id>/submissions/<submission_id>`: get the specified submission info of specified contest

  Impl Submission API with contestant auth:
    - `POST /api/contests/<contest_id>/submissions`: submit code
    - `GET /api/contests/<contest_id>/submissions/<submissions_id>/detail`: get the specified submission detail
  """

  @doc """
  Get all submission info API

  Get all contest submission info in the last three minutes

  API: `GET /api/contests/<contest_id>/submissions`

  Response:
    1. return 204 when no submission exists or contest is not start or expriation or freeze scoreborad
    2. return 200 when successfully get submission info, response `AstraeaVirgoWeb.SubmissionView.render/2` index.json
    3. return 400 when contest not exists, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server_error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def index(conn, params) do
    import AstraeaVirgo.Validate.ContestPathOperation
    with {:ok, _params} <- params |> run() |> case_validation(conn),
      {:ok, nil} <- AstraeaVirgo.Cache.Contests.Submission.index(params["contest_id"], Integer.to_string(params["now"] - 180000)) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:responsed, conn} -> conn
      {:ok, results} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.SubmissionView, "index.json", data: results)
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
  Get the specified submission info API

  API: `GET /api/contests/<contest_id>/submissions/<submission_id>`

  Response:
    1. return 204 when no submission exists
    2. return 200 when successfully get submission info, response `AstraeaVirgoWeb.SubmissionView.render/2` show.json
    3. return 400 when contest not exists, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server_error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    import AstraeaVirgo.Validate.ContestPathOperation
    with {:ok, _params} <- params |> run() |> case_validation(conn),
         {:ok, nil} <- AstraeaVirgo.Cache.Contests.Submission.show(params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:responsed, conn} -> conn
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.SubmissionView, "show.json", data: result)
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
  Get the specified submission detail API

  API: GET /api/contests/<contest_id>/submissions/<submission_id>/detail

  Response:
    1. return 204 when no submission exists
    2. return 200 when successfully get submission info, response `AstraeaVirgoWeb.SubmissionView.render/2` detail.json
    3. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 401 when user unauthorized, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    5. return 500 when server_error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def detail(conn, params) do
    import AstraeaVirgo.Validate.ContestPathOperation
    with {:ok, _params} <- params |> run() |> case_validation(conn),
         {:ok, nil} <- AstraeaVirgo.Cache.Judgement.show(params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:responsed, conn} -> conn
      {:ok, result} ->
        sub = conn |> Guardian.Plug.current_claims() |> Map.get("sub")
        case result.submitter do
          ^sub ->
            conn |>
              put_status(:ok) |>
              render(AstraeaVirgoWeb.SubmissionView, "detail.json", data: result)
          _ ->
            conn |>
              put_status(:unauthorized) |>
              render(AstraeaVirgoWeb.ErrorView, "unauthorized.json", reason: :submitter_inconsistent)
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

  @doc """
  Create the submission API

  Request: `AstraeaVirgo.Validate.SubmissionCreateOperation`

  API: POST /api/contests/<contest_id>/submissions

  Response:
    1. return 201 when successfully create submission, response `AstraeaVirgoWeb.SubmissionView` create.json
    3. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 401 when user unauthorized, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    5. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def create(conn, params) do
    import AstraeaVirgo.Validate.ContestPathOperation
    with {:ok, _params} <- params |> run() |> case_validation(conn),
         {:ok, _params} <- AstraeaVirgo.Validate.SubmissionCreateOperation.run(params),
         {:ok, problem} when not is_nil(problem) <- AstraeaVirgo.Cache.Contests.Problem.show(params["contest_id"], params["problem"]),
         {:ok, language} when not is_nil(language) <- AstraeaVirgo.Cache.Language.show(params["language"]),
         {:ok, snowflake} <- AstraeaVirgo.Snowflake.create() do
      # TODO: oj judger
      conn |>
        put_status(:created) |>
        render(AstraeaVirgoWeb.SubmissionView, "create.json", submission_id: snowflake)
    else
      {:responsed, conn} -> conn
      {:ok, nil} ->
        fields = %{"problem" => ["maybe invalid"], "language" => ["maybe invalid"]}
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, :backwards_clock} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :backwards_clock, reason: :backwards_clock)
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
