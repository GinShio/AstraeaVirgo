defmodule AstraeaVirgoWeb.ErrorView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Error Request
  """

  defp server_error_message(:internal), do: "Internal Server Error"
  defp server_error_message(:backwards_clock), do: "Generate ID Error"
  defp server_error_message(_), do: "Returned Error by Cache or Database"

  @doc """
  Response

  ## validation.json
  Response Request Params Error

  Response: Object

    | field  | type   | descript                  | value                         |
    |--------|--------|---------------------------|-------------------------------|
    | error  | string | Error Type                | "ParamsValidationError"       |
    | detail | Object | Field detailed error info | {field_name: error_info_list} |

  Example:
  ```json
  {
      "error": "ParamsValidationError",
      "detail": {
          "duration": [
              "not a number. got: \"18000000\"",
              "has wrong type; expected type: integer, got: \"18000000\""
          ],
          "id": [
              "not valid"
          ]
      }
  }
  ```

  ## unauthenticated.json
  Response for Unauthenticated Token

  Response: Object

    | field | type   | descript   | value             |
    |-------|--------|------------|-------------------|
    | error | string | Error Type | "Unauthenticated" |

  ## unauthorized.json
  Response for Unauthorized Token

  Response: Object

    | field  | type   | descript   | value          |
    |--------|--------|------------|----------------|
    | error  | string | Error Type | "Unauthorized" |
    | detail | string | reason     |                |

  Example:
  ```json
  {
      "error": "Unauthorized",
      "detail": "insufficient_permission"
  }
  ```

  ## invalid_token.json
  Response for invalid Token

  Response: Object

    | field  | type   | descript   | value          |
    |--------|--------|------------|----------------|
    | error  | string | Error Type | "InvalidToken" |

  ## no_resource_found.json
  Response for No Resource Error

  Response: Object

    | field  | type   | descript   | value              |
    |--------|--------|------------|--------------------|
    | error  | string | Error Type | "ResourceNotFound" |

  ## server_error.json
  Response for Server Error

  Response: Object

    | field  | type   | descript   | value                 |
    |--------|--------|------------|-----------------------|
    | error  | string | Error Type | "InternalServerError" |
    | detail | string | message    |                       |

  Example:
  ```json
  {
      "error": "InternalServerError",
      "detail": "Internal Server Error"
  }
  ```
  """
  def render("validation.json", assigns) do
    %{
      error: "ParamsValidationError",
      detail: assigns.fields,
    }
  end
  def render("unauthenticated.json", _assigns) do
    %{
      error: "Unauthenticated",
    }
  end
  def render("unauthorized.json", assigns) do
    %{
      error: "Unauthorized",
      detail: to_string(assigns.reason),
    }
  end
  def render("invalid_token.json", _assigns) do
    %{
      error: "InvalidToken",
    }
  end
  def render("no_resource_found.json", _assigns) do
    %{
      error: "ResourceNotFound",
    }
  end
  def render("server_error.json", assigns) do
    # TODO: log assigns.reason
    IO.inspect(assigns.reason)
    %{
      error: "InternalServerError",
      detail: server_error_message(assigns.type),
    }
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
