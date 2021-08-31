defmodule AstraeaVirgoWeb.LanguageView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Language API
  """

  @doc """
  Response

  ## index.json
  Response for index Langauges API: `GET /api/languages`

  Response: list of Object

    | field           | type     | required | descript                                       |
    |-----------------|----------|----------|------------------------------------------------|
    | id              | ID       | yes      |                                                |
    | name            | string   | yes      |                                                |
    | extensions      | string[] | yes      | language extension list, example ["cpp", "cc"] |
    | time_multiplier | double   | yes      | ratio of language time to topic requirements   |
    | mem_multiplier  | double   | yes      | ratio of language memory to topic requirements |

  Example:
  ```json
  [
      {
          "id": "Cpp",
          "name": "C++ 11 (GCC v4.9)",
          "extensions": ["cpp", "cc"],
          "time_multiplier": 1.0,
          "mem_multiplier": 1.0
      },
      {
          "id": "Python3",
          "name": "Python 3 (v3.8)",
          "extensions": ["py"],
          "time_multiplier": 3.0,
          "mem_multiplier": 3.0
      }
  ]
  ```

  ## show.json
  Response for show Language API:
    - `GET /api/languages/<language_id>`
    - `PUT /api/languages/<language_id>`

  Response: Object

    | field           | type     | required | descript                                       |
    |-----------------|----------|----------|------------------------------------------------|
    | id              | ID       | yes      |                                                |
    | name            | string   | yes      |                                                |
    | extensions      | string[] | yes      | language extension list, example ["cpp", "cc"] |
    | time_multiplier | double   | yes      | ratio of language time to topic requirements   |
    | mem_multiplier  | double   | yes      | ratio of language memory to topic requirements |

  Example:
  ```json
  {
      "id": "cpp",
      "name": "C++ 11 (GCC v4.9)",
      "extensions": ["cpp", "cc"],
      "time_multiplier": 1.0,
      "mem_multiplier": 1.0
  }
  ```

  ## create.json
  Response for create Language API: `POST /api/languages`

  Response: Object

    | field       | type | required | null | descript      |
    |-------------|------|----------|------|---------------|
    | language_id | ID   | yes      | no   | 编程语言的 ID |

  Example:
  ```json
  {"language_id": "cpp"}
  ```
  """
  def render("index.json", assigns), do: assigns.data
  def render("show.json", assigns), do: assigns.data
  def render("create.json", assigns) do
    %{
      language_id: assigns.language_id
    }
  end

end
