defmodule AstraeaVirgoWeb.ContestProblemView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Contest Problem API
  """

  @doc """
  Response

  ## index.json
  Response for index Problem API: `GET /api/contests/<contest_id>/problems`

  Response: list of Object

    | field    | type    | required | descript                  |
    |----------|---------|----------|---------------------------|
    | id       | ID      | yes      |                           |
    | name     | string  | yes      |                           |
    | label    | string  | yes      | Problem Label             |
    | testcase | integer | yes      | number of testcase        |
    | rgb      | string  | yes      |                           |

  ## show.json
  Response for show Contest Problem API:
    - `GET /api/contests/<contest_id>/problems/<problem_id>`
    - `PUT /api/contests/<contest_id>/problems/<problem_id>`

  Response: Object

    | field    | type    | required | descript                  |
    |----------|---------|----------|---------------------------|
    | id       | ID      | yes      |                           |
    | name     | string  | yes      |                           |
    | label    | string  | yes      | Problem Label             |
    | testcase | integer | yes      | number of testcase        |
    | rgb      | string  | yes      |                           |

  ## create.json
  Response for create Language API: `POST /api/problems`

  Response: Object

    | field       | type | required | null | descript      |
    |-------------|------|----------|------|---------------|
    | problem_id  | ID   | yes      | no   | 问题的 ID     |
  """
  def render("index.json", assigns), do: assigns.data
  def render("show.json", assigns), do: assigns.data

end
