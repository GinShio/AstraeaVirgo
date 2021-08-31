defmodule AstraeaVirgoWeb.UserView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for User API
  """

  @doc """
  Response

  ## create.json
  Response for Register: `POST /api/users`

  Response: Objecy

    | field | type |
    |-------|------|
    | token | JWT  |

  Example:
  ```json
  {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJBc3RyYWVhIE9ubGluZUp1ZGdlIFByb2plY3QiLCJleHAiOjE2MjA0NzM1NTIsImlhdCI6MTYyMDQ3MzI1MiwiaXNzIjoiaHR0cDovL2V4YW1wbGUuY29tIiwianRpIjoiMTM3OGIyMDYtNTg3Zi00NTI5LWJkM2YtMGYwZTNhODBmNTEyIiwibmJmIjoxNjIwNDczMjUxLCJwZW0iOnsiZGVmYXVsdCI6WyJwdWJsaWMiXX0sInN1YiI6ImlAZ2luc2hpby5vcmciLCJ0eXAiOiJhY2Nlc3MifQ.q6k3AjXd22yTVqkXMh_fCbub47oS2160OMZ6Puzgyes"}
  ```
  """
  def render("create.json", assigns) do
    %{
      token: assigns.token,
    }
  end
end
