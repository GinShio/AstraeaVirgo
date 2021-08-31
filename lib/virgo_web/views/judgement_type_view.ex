defmodule AstraeaVirgoWeb.JudgementTypeView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Judgement Type API
  """

  defp ce() do
    %{
      id: "CE",
      name: "Compile Error",
      penalty: false,
      solved: false
    }
  end
  defp ac() do
    %{
      id: "AC",
      name: "Accepted",
      penalty: false,
      solved: true
    }
  end
  defp tle() do
    %{
      id: "TLE",
      name: "Time Limit Exceeded",
      penalty: false,
      solved: false
    }
  end
  defp rte() do
    %{
      id: "RTE",
      name: "Run-Time Error",
      penalty: true,
      solved: false
    }
  end
  defp wa() do
    %{
      id: "WA",
      name: "Wrong Answer",
      penalty: true,
      solved: false
    }
  end

  defp judgement_type("CE"), do: ce()
  defp judgement_type("AC"), do: ac()
  defp judgement_type("TLE"), do: tle()
  defp judgement_type("RTE"), do: rte()
  defp judgement_type("WA"), do: wa()

  @doc """
  Response

  ## index.json
  Response for index Judgement Type API: `GET /api/judgement-types`

  Response: list of Object

    | field   | type    | required | null | descript                 |
    |---------|---------|----------|------|--------------------------|
    | id      | ID      | yes      | no   |                          |
    | name    | string  | yes      | no   |                          |
    | penalty | boolean | no       | yes  | 当前判题结果是否用罚时   |
    | solved  | boolean | no       | yes  | 当前判题结果是否解决问题 |

  Example:
  ```json
  [
      {
          "id": "CE",
          "name": "Compile Error",
          "penalty": false,
          "solved": false
      }
  ]
  ```

  ## show.json
  Response for show Judgement Type API: `GET /api/judgement-types/<judgement_type_id>`

  Response: Object

    | field   | type    | required | null | descript                 |
    |---------|---------|----------|------|--------------------------|
    | id      | ID      | yes      | no   |                          |
    | name    | string  | yes      | no   |                          |
    | penalty | boolean | no       | yes  | 当前判题结果是否用罚时   |
    | solved  | boolean | no       | yes  | 当前判题结果是否解决问题 |

  Example:
  ```json
  {
      "id": "CE",
      "name": "Compile Error",
      "penalty": false,
      "solved": false
  }
  ```
  """
  def render("index.json", _assigns) do
    [
      ce(),
      ac(),
      tle(),
      rte(),
      wa(),
    ]
  end
  def render("show.json", assigns) do
    judgement_type(assigns.type)
  end

end
