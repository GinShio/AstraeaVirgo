defmodule AstraeaVirgoWeb.ProblemView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Problem API
  """

  @doc """
  Response

  ## index.json
  Response for index Problems API: `GET /api/problems`

  Response: list of Object

    | field    | type    | required | descript                  |
    |----------|---------|----------|---------------------------|
    | id       | ID      | yes      |                           |
    | name     | string  | yes      |                           |
    | category | string  | yes      | category of problem       |
    | ordinal  | Ordinal | yes      | problem ordinal           |
    | testcase | integer | yes      | number of testcase        |
    | lock     | boolean | yes      | if true that can't submit |
    | public   | boolean | yes      |                           |
    | total    | integer | yes      | number of submissions     |
    | ac       | integer | yes      | number of ac submissions  |

  ## show.json
  Response for show Problem API:
    - `GET /api/problems/<problem_id>`
    - `PUT /api/problems/<problem_id>`

  Response: Object

    | field    | type    | required | descript                  |
    |----------|---------|----------|---------------------------|
    | id       | ID      | yes      |                           |
    | name     | string  | yes      |                           |
    | category | string  | yes      | category of problem       |
    | ordinal  | Ordinal | yes      | problem ordinal           |
    | testcase | integer | yes      | number of testcase        |
    | lock     | boolean | yes      | if true that can't submit |
    | public   | boolean | yes      |                           |
    | total    | integer | yes      | number of submissions     |
    | ac       | integer | yes      | number of ac submissions  |

  ## detail.json
  Response for Problem Detail API:
    - `GET /api/problems/<problem_id>/detail`
    - `GET /api/contests/<contest_id>/problems/<problem_id>/detail`

  Response: Object

    | field        | type    | required | descript                  |
    |--------------|---------|----------|---------------------------|
    | id           | ID      | yes      |                           |
    | public       | boolean | yes      |                           |
    | detail       | Base64  | yes      | detail of problem         |
    | mime         | string  | yes      | mime type of detail       |
    | time_limit   | integer | yes      | time limit (ms)           |
    | memory_limit | integer | yes      | memory limit (kiB)        |

  ## create.json
  Response for create Language API: `POST /api/problems`

  Response: Object

    | field       | type | required | null | descript      |
    |-------------|------|----------|------|---------------|
    | problem_id  | ID   | yes      | no   | 问题的 ID     |
  """
  def render("index.json", assigns), do: assigns.data
  def render("show.json", assigns), do: assigns.data
  def render("detail.json", assigns), do: assigns.data
  def render("create.json", assigns) do
    %{
      problem_id: assigns.problem_id
    }
  end

end
