defmodule AstraeaVirgoWeb.TokenView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Token or session API
  """

  @doc """
  Response

  ## create.json
  Response for get new token API
    - `POST /api/tokens`
    - `POST /api/sessions`
    - `PUT /api/sessions/<user_id>`

  Response: Object

    | field | type |
    |-------|------|
    | token | JWT  |

  Example:
  ```json
  {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJBc3RyYWVhIE9ubGluZUp1ZGdlIFByb2plY3QiLCJleHAiOjE2MjA0NzM1NTIsImlhdCI6MTYyMDQ3MzI1MiwiaXNzIjoiaHR0cDovL2V4YW1wbGUuY29tIiwianRpIjoiMTM3OGIyMDYtNTg3Zi00NTI5LWJkM2YtMGYwZTNhODBmNTEyIiwibmJmIjoxNjIwNDczMjUxLCJwZW0iOnsiZGVmYXVsdCI6WyJwdWJsaWMiXX0sInN1YiI6ImlAZ2luc2hpby5vcmciLCJ0eXAiOiJhY2Nlc3MifQ.q6k3AjXd22yTVqkXMh_fCbub47oS2160OMZ6Puzgyes"}
  ```

  ## generate_error.json
  Response for request generate token Error

  Response: Object

    | field  | type   | descript   | value                |
    |--------|--------|------------|----------------------|
    | error  | string | Error Type | "GenerateTokenError" |
    | detail | string | reason     |                      |
  """
  def render("create.json", params), do: %{token: params.token}
  def render("generate_error.json", params) do
    %{
      error: "GenerateTokenError",
      detail: params.reason,
    }
  end

 end
