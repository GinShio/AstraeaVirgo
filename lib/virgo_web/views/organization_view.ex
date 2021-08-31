defmodule AstraeaVirgoWeb.OrganizationView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Organization API
  """

  @doc """
  Response

  ## index.json
  Response for index Organization API: `GET /api/organizations`

  Response: list of Object

    | field       | type   | required | null | descript |
    |-------------|--------|----------|------|----------|
    | id          | ID     | yes      | no   |          |
    | name        | string | yes      | no   | 名称     |
    | formal_name | string | no       | yes  | 全称     |
    | url         | URL    | no       | yes  | 官网     |
    | logo        | File   | no       | yes  |          |

  Example:
  ```json
  [
      {
          "id": "CN",
          "name": "China",
          "formal_name": "People's Republic of China",
          "url": "http://www.gov.cn/",
          "logo": {
              "href": "https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People%27s_Republic_of_China.svg",
              "mime": "image/svg+xml"
          }
      },
      {
          "id": "TW",
          "name": "Taiwan",
          "formal_name": "Taiwan, Province of China",
          "logo": {
              "href": "https://upload.wikimedia.org/wikipedia/commons/7/72/Flag_of_the_Republic_of_China.svg",
              "mime": "image/svg+xml"
          }
      }
  ]
  ```

  ## show.json
  Response for show Organization API:
    - `GET /api/organizations/<organization_id>`
    - `PUT /api/organization/<organization_id>`

  Response: Object

    | field       | type   | required | null | descript |
    |-------------|--------|----------|------|----------|
    | id          | ID     | yes      | no   |          |
    | name        | string | yes      | no   | 名称     |
    | formal_name | string | no       | yes  | 全称     |
    | url         | URL    | no       | yes  | 官网     |
    | logo        | File   | no       | yes  |          |

  Example:
  ```json
  {
      "id": "CN",
      "name": "China",
      "formal_name": "People's Republic of China",
      "url": "http://www.gov.cn/",
      "logo": {
          "href": "https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People%27s_Republic_of_China.svg",
          "mime": "image/svg+xml"
      }
  }
  ```

  ## create.json
  Response for create Organization API: `POST /api/organizations`

  Response: Object

    | field           | type | required | null | descript      |
    |-----------------|------|----------|------|---------------|
    | organization_id | ID   | yes      | no   | 组织机构的 ID |

  Example:
  ```json
  {"organization_id": "CN"}
  ```
  """
  def render("index.json", assigns), do: assigns.data
  def render("show.json", assigns), do: assigns.data
  def render("create.json", assigns) do
    %{
      organization_id: assigns.organization_id
    }
  end

end
